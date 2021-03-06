if ttt_wowozela == nil then
    ttt_wowozela = {}

    ttt_wowozela.ValidNotes =
    {
        ["Left"] = IN_ATTACK,
        ["Right"] = IN_ATTACK2
    }

    ttt_wowozela.ValidKeys =
    {
        IN_ATTACK,
	    IN_ATTACK2,
        IN_WALK,
        IN_SPEED,
        IN_USE
    }
end
if SERVER then AddCSLuaFile("ttt_wowozela.lua") end

--easylua.StartWeapon("ttt_wowozela")
SWEP.Base = "weapon_tttbase"

SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.PrintName = "TTT Wowozela"

SWEP.SlotPos = 1
SWEP.Slot = 8

SWEP.Spawnable = true

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.HoldType = "normal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = "models/weapons/w_bugbait.mdl"
SWEP.DrawWeaponInfoBox = true

SWEP.Kind = WEAPON_ROLE
SWEP.Icon = "VGUI/ttt/ttt_wowozela"
SWEP.AutoSpawnable = false
SWEP.LimitedStock = false
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.InLoadoutFor = { ROLE_INNOCENT, ROLE_TRAITOR }

if SERVER then
   resource.AddFile("materials/VGUI/ttt/ttt_wowozela.vmt")
end

SWEP.EquipMenuData = {
   type = "TTT Wowozela",
   desc = "Make some noise!"
};

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "NoteLeft")
    self:NetworkVar("Int", 1, "NoteRight")
end

function SWEP:PrintWeaponInfo() end
function SWEP:DrawWeaponSelection() end
function SWEP:DrawWorldModel() return true end
function SWEP:CanPrimaryAttack() return false end
function SWEP:CanSecondaryAttack() return false end
function SWEP:ShouldDropOnDie() return false end
function SWEP:Reload() return false end

function SWEP:Initialize()
    if self.SetWeaponHoldType then
        self:SetWeaponHoldType("normal")
    end
    
    self:SetNoteLeft(1)
    self:SetNoteRight(1)
end

if SERVER then
    function SWEP:OnDrop()
        self:Remove()
    end
end

function SWEP:Deploy()
    self.Think = self._Think
    return true
end

function SWEP:Holster()
    if not self.Owner:KeyDown(IN_RELOAD) then
        return true
    end
    
    return false
end

function SWEP:OnKeyEvent(key, press)
end

function SWEP:_Think()
    if self.Owner and self.Owner:IsValid() and self.Owner:GetViewModel():IsValid() then
        self.Owner:GetViewModel():SetNoDraw(true)
        self.Think = nil
    end
end

function SWEP:GetViewModelPosition(pos, ang)
    pos.x = 35575
    pos.y = 35575
    pos.z = 35575

    return pos, ang
end

if CLIENT then
    local size = 80
    local count = 4
    
    surface.CreateFont(
        "WowozelaFont",
        {
            font		= "Roboto Bk",
            size		= size,
            weight		= 1000,
        }
    )
    
    surface.CreateFont(
        "WowozelaFont2",
        {
            font		= "Roboto Bk",
            size		= 35,
            weight		= 1000,
        }
    )
    local wason = false
    local selection1 = 1
    local selection2 = 1
    local alpha = 0
    local showing = 5
    
    local space = 10
    local size_diagy
    local maxheight = 0
    ttt_wowozela.xPos = 0
    ttt_wowozela.xPos2 = 0
    local indexs = {}
    local PanelWidth = ScrW() * 0.75
    local function PosToIndex(posX)
        --local posX = size_diag - posX
        for k,v in pairs(indexs) do
            if posX > v[1] and posX <= v[2] then
                return k
            end 
        end
        return 1
    end

    function SWEP:DrawHUD()

        local left = self.Owner:KeyDown(IN_ATTACK) or input.IsMouseDown(MOUSE_LEFT)
        local right = self.Owner:KeyDown(IN_ATTACK2) or input.IsMouseDown(MOUSE_RIGHT)
        

        
        local names = ttt_wowozela.Samples
        local edge = 2
        local PanelHeight = maxheight * 2 + 10
        local PanelX = ScrW()/2 - PanelWidth/2
        local PanelY = ScrH() - PanelHeight
        local total = (ttt_wowozela and ttt_wowozela.Samples) and #ttt_wowozela.Samples or 0
        surface.SetFont("WowozelaFont2")
        if not size_diag or maxheight == 0 then
            size_diag = space
            for I = 1, total do
                
                local width, height = surface.GetTextSize(names[I][2])
                indexs[I] = {size_diag, size_diag + space + width}
                size_diag = size_diag + space + width
                if height > maxheight then
                    maxheight = height
                end

            end
            ttt_wowozela.xPos = -PanelWidth/2
            ttt_wowozela.xPos2 = -PanelWidth/2
        end

        
        
        surface.SetDrawColor(Color(150, 150, 150))
        
        draw.RoundedBoxEx(16, PanelX - edge, PanelY - edge, PanelWidth + edge*2, PanelHeight + edge*2, Color(50, 50, 50), true, true)
        draw.RoundedBoxEx(16, PanelX, PanelY, PanelWidth, PanelHeight, Color(100, 100, 100), true, true)
        local offsetX = 0
        for I=1, #names do
            local option = names[I][2]
            local width, height = surface.GetTextSize(option)
            
            render.SetScissorRect(PanelX, PanelY, PanelX + PanelWidth, PanelY + PanelHeight, true)

            local col1 = Color( 75, 75, 75, 255 )
            local col2 = Color( 75, 75, 75, 255 )
            if I == PosToIndex(ttt_wowozela.xPos + PanelWidth/2) then
                col1 = Color( 150, 50, 50, 255 )
            end
            if I == PosToIndex(ttt_wowozela.xPos2 + PanelWidth/2) then
                col2 = Color( 150, 50, 50, 255 )
            end
            draw.DrawText(option, "WowozelaFont2", PanelX + offsetX - ttt_wowozela.xPos, PanelY, col1, TEXT_ALIGN_LEFT )
            draw.DrawText(option, "WowozelaFont2", PanelX + offsetX - ttt_wowozela.xPos2, PanelY + maxheight, col2, TEXT_ALIGN_LEFT )
            render.SetScissorRect(PanelX, PanelY, PanelX + PanelWidth, PanelY + PanelHeight, false)
            offsetX = offsetX + width + space
        end

        if self.Owner:KeyDown(IN_RELOAD) then
            if not wason then
                gui.EnableScreenClicker(true)
                wason = true
            end
            local mouseX, mouseY = gui.MousePos()
            local movePos = ((ScrW()/2 - mouseX) / (ScrW()/2)) * -32
            if left then
                ttt_wowozela.xPos = math.Clamp(ttt_wowozela.xPos + movePos, -PanelWidth/2, size_diag-PanelWidth/2)
            elseif right then
                ttt_wowozela.xPos2 = math.Clamp(ttt_wowozela.xPos2 + movePos, -PanelWidth/2, size_diag-PanelWidth/2)  
            end
        else
            if(wason) then
                gui.EnableScreenClicker(false)
                wason = false
            end
        end
    end


    hook.Add("KeyRelease", "WowozelaFinalizeSelection", function(ply, key)
        if key == IN_RELOAD and PanelWidth then
            local index = PosToIndex(ttt_wowozela.xPos + PanelWidth/2) 
            if index ~= selection1 then
                selection1 = index
                RunConsoleCommand("ttt_wowozela_select_left", index)
            end

            local index2 = PosToIndex(ttt_wowozela.xPos2 + PanelWidth/2) 
            if index2 ~= selection2 then
                selection2 = index2
                RunConsoleCommand("ttt_wowozela_select_right", index2)
            end
        end
    end)
end

--easylua.EndWeapon(true, true)