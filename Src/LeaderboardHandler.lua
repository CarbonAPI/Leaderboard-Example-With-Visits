local ds = game:GetService("DataStoreService"):GetOrderedDataStore("PlayersData")

function createGui(ypos, id, visits)
	wait()
	if game.Workspace:WaitForChild("LeaderBoard"):FindFirstChild("SurfaceGui") == nil then
		Instance.new("SurfaceGui", game.Workspace.LeaderBoard)
	end
	local sGui = game.Workspace.LeaderBoard:FindFirstChild("SurfaceGui")
	local model = game.ReplicatedStorage:WaitForChild("Frame"):Clone()
	model.Parent = sGui
	model.Position = UDim2.new(.05, 0, ypos, 0)
	model.Name = id
	model.ImageFrame.ImageTile.Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=" .. id
	model.NameTag.Text = id
	if visits ~= nil then
		model.Visits.Text = "Visits: " .. visits
	end
end

coroutine.resume(coroutine.create(function()
	function joining()
		local pages = ds:GetSortedAsync(false, 7) 							
		local currentPageNumber = 0
		while true do	
			if currentPageNumber < 1 then
				print("Page: " .. currentPageNumber)
				local data = pages:GetCurrentPage()              				
				for i, pair in ipairs(data) do 			             				
					print(pair.key .. ": " .. pair.value .. " points, with rank #: " .. i)
					local startPos = .15
					local size = .1
					local space = .01
					local y = startPos + ((i - 1) * size) + ((i - 1) * space)
					createGui(y, pair.key, pair.value)
				end
				if pages.IsFinished then										
					break
				end
				pages:AdvanceToNextPageAsync()									
				currentPageNumber = currentPageNumber + 1
			else
				break
			end
		end
	end
end))

game.Players.PlayerAdded:connect(function(plr)
	wait(.1)
	if ds:GetAsync(plr.Name) == nil then
		ds:SetAsync(plr.Name, 1)
		joining()
	else
		ds:IncrementAsync(plr.Name, 1)
		joining()
	end	
end)
