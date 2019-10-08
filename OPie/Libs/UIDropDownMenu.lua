if (COMMUNITY_UIDD_REFRESH_PATCH_VERSION or 0) < 2 then
	COMMUNITY_UIDD_REFRESH_PATCH_VERSION = 2
	if select(4,GetBuildInfo()) >= 8e4 then
		-- CommunitiesFrame is linked to FriendsFrame on 1.13.2,
		-- CleanDropdowns would loop until it runs out of stack.
		local function CleanDropdowns()
			if COMMUNITY_UIDD_REFRESH_PATCH_VERSION ~= 2 then
				return
			end
			local f, f2 = FriendsFrame, FriendsTabHeader
			local s = f:IsShown()
			f:Hide()
			f:Show()
			if not f2:IsShown() then
				f2:Show()
				f2:Hide()
			end
			if not s then
				f:Hide()
			end
		end
		hooksecurefunc("Communities_LoadUI", CleanDropdowns)
		hooksecurefunc("SetCVar", function(n)
			if n == "lastSelectedClubId" then
				CleanDropdowns()
			end
		end)
	end
end