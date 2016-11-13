require "match"

if has("(.+)dog.?","I am a dog ",function(s) out=s end) then
	print(out.."dog too ")
else
	print("This world is mad !")
end
