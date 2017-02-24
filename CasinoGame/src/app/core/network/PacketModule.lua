
module("app.core.network.PacketModule", package.seeall)

require("luabuf")

local PacketModule = app.core.network.PacketModule

PacketModule.SOCKET_HEADER_LENGTH=14

function PacketModule.buildPacket(iType,passportId,iBody)

    local headbuf=luabuf.iobuffer_new()
    
    local messageLength=PacketModule.SOCKET_HEADER_LENGTH+string.len(iBody)
    
    headbuf:iobuffer_write_int32(messageLength)
    
    headbuf:iobuffer_write_short(iType)
    
    headbuf:iobuffer_write_int64(passportId)
    
    local headstr=headbuf:iobuffer_str()
    
    local packet=headstr..iBody
    
    return packet
end


function PacketModule.subPacketBody(data)
    local body=string.sub(data,PacketModule.SOCKET_HEADER_LENGTH+1,string.len(data))
    return body
end

function PacketModule.getPacketBody(data)

    if data and string.len(data) >= PacketModule.SOCKET_HEADER_LENGTH then 

        local mybuf=luabuf.iobuffer_new()
        local headdata=PacketModule.subPacketHead(data)
        mybuf:iobuffer_write_str(headdata)
        
        local messagelen=mybuf:iobuffer_read_int32()
        local type=mybuf:iobuffer_read_short()
        
        if string.len(data) >= messagelen then 

            local body = string.sub(data,PacketModule.SOCKET_HEADER_LENGTH+1, messagelen)
            
            return type, body, string.sub(data,messagelen+1)
        else
            return type, nil, data
        end
    else
        if data then print("Error Data Len :",string.len(data)) end
    end
    
    return nil, nil, data
end

function PacketModule.subPacketHead(data)
    local body=string.sub(data,1,PacketModule.SOCKET_HEADER_LENGTH)
    return body
end

