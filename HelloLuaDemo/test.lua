print("1")
function g( a,b,... )
	tb = {}
	table.insert(tb,1,a)
	table.insert(tb,1,b)

	for i,val in pairs(arg) do
		if i == "n" then
			break
		end
		-- print(i,val)
		table.insert(tb,1,val)
	end

	for i,val in pairs(arg) do
		print(i,val)
	end

	print(#tb)
	return tb[1],tb[2],tb[3],tb[4],tb[5]
end

a,b,c,d,e = g(2,3,4,5,6)
print(a,b,c,d,e)



