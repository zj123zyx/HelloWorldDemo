local FBPlatform = class("FBPlatform")

FBPlatform.downloading = false
FBPlatform.FBPictrueDownTask = {}

FBPlatform.isLogined = false

FBPlatform.facebookCallBack = nil
FBPlatform.data_fun = nil

function FBPlatform.getIsLogin()
    return plugin.FacebookAgent:getInstance():isLoggedIn()
end

function FBPlatform.login(callback, permissions)
    -- if plugin.FacebookAgent:getInstance():isLoggedIn() then
    --     print("already login in")
    -- else
        if permissions then
            --local permissions = "create_event,create_note,manage_pages,publish_actions,user_about_me"
            plugin.FacebookAgent:getInstance():login(permissions, function(ret, msg)
                print(ret, msg)
                callback(ret, msg)
                end
            )
        else
            print("not permissions")

            plugin.FacebookAgent:getInstance():login(function(ret, msg)
                print(ret, msg)
                callback(ret, msg)
            end
            )

        end
        
    --end 
end

function FBPlatform.logout()
    plugin.FacebookAgent:getInstance():logout()
end

function FBPlatform.getUid()
    if plugin.FacebookAgent:getInstance():isLoggedIn() then
        return plugin.FacebookAgent:getInstance():getUserID()
    else
        print("User haven't been logged in")
    end
end

function FBPlatform.getToken()
    if plugin.FacebookAgent:getInstance():isLoggedIn() then
        return plugin.FacebookAgent:getInstance():getAccessToken()
    else
        print("User haven't been logged in")
    end
end

function FBPlatform.requestAPI(path, method, params, callback)
    --local path = "/me/photos"
    --local params = {url = "http://files.cocos2d-x.org/images/orgsite/logo.png"}
    --method = plugin.FacebookAgent.HttpMethod.POST
    core.Waiting.show()
    plugin.FacebookAgent:getInstance():api(path, method, params, function(ret, msg)
        callback(ret,msg)
        core.Waiting.hide()
    end)
end

function FBPlatform.share(params, callback)
    if plugin.FacebookAgent:getInstance():canPresentDialogWithParams(params) then
        
        plugin.FacebookAgent:getInstance():dialog(params, function(ret, msg)
                    print(msg)
                    callback(ret, msg)
                end)
    else
        params.dialog = "feedDialog"
        plugin.FacebookAgent:getInstance():dialog(params, function(ret, msg)
                    print(msg)
                    callback(ret, msg)
                end)
    end
end

function FBPlatform.appRequest(params, callback)
    plugin.FacebookAgent:getInstance():appRequest(params, function(ret, msg)
            print(msg)
            callback(ret, msg)
        end)
end

-----------------------------------------------------------
-- shareFacebook 
-----------------------------------------------------------
function FBPlatform.shareFacebookImpl(sharedcallback)
    local islogin = core.FBPlatform.getIsLogin()
    if islogin then

        local content = DICT_FACEBOOK_FEED["1"].content
        local params = {
                dialog = "shareLink",
                name   = content.name,
                caption = content.caption,
                description = content.description,
                link   = content.link,
                picture = content.picture,
            }

        core.FBPlatform.share(params, function( ret, msg )
            local invite = json.decode(msg)
            if sharedcallback then sharedcallback() end
            --table.dump(invite, "invite")
        end)


    else
        local callback = function(isConnect)
            if isConnect then
                core.FBPlatform.shareFacebookImpl(sharedcallback)
                --self:connectToShareFacebook()
            else
                if sharedcallback then sharedcallback() end
            end
        end

        scn.ScnMgr.addView("FBConnectView",{coins = CONNECTFB_REWARD_COINS, callback = callback})
    end
end

function FBPlatform.onLoginImpl(callback)
    
    app.logining = true
    
    local model = app:getUserModel()
    local cls = model.class
    local properties = model:getProperties({cls.facebook})
    local fb = properties[cls.facebook]

    local facebookCallBack = function(ret, msg)

        app.logining = false

        if tonumber(ret) == 1 then

            app.logining = false
            scn.ScnMgr.addView("CommonView",
                {
                    title="Connection Error",
                    content="Facebook connection failed,Please check the internet and try again.",
                })

            core.Waiting.forceHide()

            return
        end

        if fb[cls.fb.fbid] == nil then

            properties[cls.pictureId] = 0

            local modifyProperties = model:getProperties({cls.name, cls.extinfo})
            local ei = {}
            ei[cls.ei.signature] = modifyProperties[cls.extinfo][cls.ei.signature]
            ei[cls.pictureId] = 0

            net.UserCS:modifyPlayerInfo(model:getPid(), modifyProperties[cls.name], ei)

        end

        local msgJson = json.decode(msg)
                                
        fb[cls.fb.fbid]                         = msgJson.id
        fb[cls.fb.name]                         = msgJson.name
        fb[cls.fb.token]                        = msgJson.accessToken
        fb[cls.fb.tokenExpireDate]              = msgJson.tokenExpireDate

        print("fb name : ", fb[cls.fb.fbid], fb[cls.fb.name], fb[cls.fb.token], fb[cls.fb.tokenExpireDate])
        
        properties[cls.facebookId] = fb[cls.fb.fbid]
        properties[cls.facebook] = fb

        model:setProperties(properties)
        model:serializeModel()

        net.UserAuthCS:thirdLogin(fb[cls.fb.fbid], "name",
            function()
                local path = "/me/friends"
                local params = {fields="id"} -- @"id,name,first_name,last_name"

                core.FBPlatform.requestAPI(path, plugin.FacebookAgent.HttpMethod.GET, params, function( ret, msg )
                    -- body
                            
                    local friends = json.decode(msg)

                    local fbs = ""
                    local idx = 1

                    table.dump(friends, "friends")

                    for k,v in pairs(friends.data) do

                        if idx == 1 then
                            fbs = fbs..v.id
                        else
                            fbs = fbs..","..v.id
                        end
                        idx = idx + 1
                        print(k,v, v.id)
                    end
                                    
                    net.FriendsCS:addFacebookFriends(fbs, callback)
                    

                end
                )
            end
        )

        -- AppLuaApi:getInstance():downloadPhoto(core.FBPlatform.getUid())

    end


    local permissions = "user_friends,user_photos,public_profile"

    core.FBPlatform.login(function(ret, msg)
        FBPlatform.facebookCallBack = facebookCallBack
        FBPlatform.data_fun = facebookCallBack
        FBPlatform.facebookCallBack(ret, msg)
        if not FBPlatform.facebookCallBack then
            FBPlatform.data_fun(ret, msg)
        end
        FBPlatform.data_fun = nil
    end, permissions)

end

function FBPlatform.getNextTask()
    for k,v in pairs(FBPlatform.FBPictrueDownTask) do
        if v.downloading == false then
            return k,v
        end
    end
    return nil,nil
end

function FBPlatform.downFBPictureImage(fbId, task)

    if fbId and task then
            
        FBPlatform.downloading = true
        task.downloading = true

        AppLuaApi:getInstance():postFBListenerLua(function(event)
            -- body
            if event.photo and event.photo == "-1" then
                print("photo download error")
            else
                if task.onComplete then task.onComplete(event.photo.path) end
            end

            -- next one
            FBPlatform.downloading = false
            FBPlatform.FBPictrueDownTask[event.photo.id] = nil

            local fbId, task = FBPlatform.getNextTask()
            FBPlatform.downFBPictureImage(fbId, task)

        end);

        AppLuaApi:getInstance():downloadPhoto(fbId)
    end
end

function FBPlatform.pushDownTask(facebookId, callback)

    FBPlatform.FBPictrueDownTask[facebookId] = {downloading = false, onComplete=callback}   

    if FBPlatform.downloading == false then

        local fbId, task = FBPlatform.getNextTask()
        FBPlatform.downFBPictureImage(fbId, task)
        
    end

end

function FBPlatform.onEnterBackground()
    if FBPlatform.data_fun then
        FBPlatform.facebookCallBack = FBPlatform.data_fun
    end
end

function FBPlatform.onEnterForeground()
    if app.logining then
        app.logining = false
        FBPlatform.data_fun = FBPlatform.facebookCallBack
        FBPlatform.facebookCallBack = nil
    end
end

return FBPlatform