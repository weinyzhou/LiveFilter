

function string.split(str,delim)  
    local i,j,k  
    local t = {}  
    k = 1  
    while true do  
        i,j = string.find(str,delim,k)  
        if i == nil then  
            table.insert(t,string.sub(str,k))  
            return t  
        end  
        table.insert(t,string.sub(str,k,i - 1))  
        k = j + 1  
    end  
end

function string.trim(s)
 if not s then
    return nil;
 end
 local from = s:match"^%s*()"
 return from > #s and "" or s:match(".*%S", from)
end

local output=function(msg)
	print("error:"..msg);
end

local strToTable=function(line)
	local pos=string.find(line,":");
	if pos==nil or pos<1 then
		return nil;
	end
	local name=string.sub(line,1,pos-1);
	local value=string.sub(line,pos+1);
	return name,value;
end

local getpath=function(line)
	
	local pos=string.find(line," ");
	if pos==nil or pos<1 then
		return nil;
	end

	line=string.sub(line,pos+1);
	
	pos=string.find(line," ");
	if pos==nil or pos<1 then
		return nil;
	end
	local cur=string.sub(line,1,pos-1);
	if(cur==nil) then
		return "";
	end
	
	output(cur);
	return cur;
end

local findHost=function (tab)
	for i,v in ipairs(tab) do
		if v.n=="Host" then
			return v.v;
		end
	end
	return nil;
end
function table.size(tbl)
	local size=0;
	for i,v in ipairs(tbl) do
		size=size+1;
	end
	return size;
end




function parseEvent(srcIp,tarIp,data,pNet)
	local http_lines=string.split(data,"\r\n");
	local path=getpath(http_lines[1]);
	if path==nil then
		return false;
	end
	
	local headers={};
	for i,v in ipairs(http_lines) do
		v=string.trim(v);
		if i~=1 and v~=nil and string.len(v)>2 then
			local name,value=strToTable(v);
			if name~=nil and value~=nil then
				table.insert(headers,{n=name,v=value});
			end
		end
	end
	local host=findHost(headers);
	print("host:",host);
	host=string.trim(host);
	--添加到结果队列
	--"Unkown" 类型
	--path 结果地址
	--data 数据
	addFilterItem(pNet,srcIp,tarIp,"Unkown",path,data);
	
	return true;
end

