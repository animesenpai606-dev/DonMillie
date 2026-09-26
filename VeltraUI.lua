-- Apex  |  Universal Hub  |  UI Library
-- loadstring() this from ApexLoader.lua

local function ApexUI(LocalPlayer, Players, RunService, gameKey)

-- SERVICES ─────────────────────────────────────────────────────────────────
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- GAME CONFIGS ─────────────────────────────────────────────────────────────
-- Each game gets its own accent color, icon text, and label
local GAME_CFG = {
    rofootball   = { accent=Color3.fromRGB(255,255,255), dim=Color3.fromRGB(180,180,180), icon="RF", label="Rofootball"   },
    hsbl         = { accent=Color3.fromRGB(255,255,255), dim=Color3.fromRGB(180,180,180), icon="BB", label="HoopSimBL"   },
    footballfusion = { accent=Color3.fromRGB(255,255,255), dim=Color3.fromRGB(180,180,180), icon="FF", label="Football Fusion" },
    unknown      = { accent=Color3.fromRGB(255,255,255), dim=Color3.fromRGB(180,180,180), icon="?",  label="Unknown Game" },
}
local cfg = GAME_CFG[gameKey] or GAME_CFG.unknown

-- PALETTE ──────────────────────────────────────────────────────────────────
local AC      = cfg.accent                         -- white accent
local AC2     = cfg.dim                            -- dimmer white
local BG0     = Color3.fromRGB(  8,   8,  10)     -- near-black
local BG1     = Color3.fromRGB( 14,  14,  18)     -- dark panel
local BG2     = Color3.fromRGB( 20,  20,  26)     -- mid panel
local BG3     = Color3.fromRGB( 26,  26,  34)     -- card bg
local BDR     = Color3.fromRGB( 40,  40,  55)     -- border
local TW      = Color3.fromRGB(240, 240, 250)     -- primary text
local TM      = Color3.fromRGB(110, 110, 130)     -- muted text
local DIV     = Color3.fromRGB( 24,  24,  32)     -- divider
local GREEN   = Color3.fromRGB( 50, 200, 100)
local RED     = Color3.fromRGB(220,  60,  60)

local GUI_W   = 700
local GUI_H   = 500
local SB_W    = 152
local TB_H    = 46
local toggleKey = Enum.KeyCode.LeftAlt
local isMobile  = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- HELPERS ───────────────────────────────────────────────────────────────────
local function mk(class, props)
    local i = Instance.new(class)
    for k,v in pairs(props or {}) do i[k]=v end
    return i
end
local function corner(p, r)
    local c=Instance.new("UICorner"); c.CornerRadius=r or UDim.new(0,8); c.Parent=p
end
local function bstroke(p, col, t)
    local s=Instance.new("UIStroke"); s.Color=col or BDR; s.Thickness=t or 1
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p
end
local function lbl(p, text, sz, col, bold)
    return mk("TextLabel",{Text=text,TextSize=sz or 13,TextColor3=col or TW,
        Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,
        Size=UDim2.new(1,0,1,0),Parent=p})
end
local function hdiv(p)
    return mk("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=DIV,BorderSizePixel=0,Parent=p})
end
local function tw(inst, props, t)
    TweenService:Create(inst,TweenInfo.new(t or 0.15,Enum.EasingStyle.Quint),props):Play()
end
local function isClick(t) return t==Enum.UserInputType.MouseButton1 or t==Enum.UserInputType.Touch end
local function isMove(t)  return t==Enum.UserInputType.MouseMovement or t==Enum.UserInputType.Touch end

-- Toggle switch
local function makeSwitch(parent)
    local bg=mk("TextButton",{Size=UDim2.new(0,44,0,22),Position=UDim2.new(1,-56,0.5,-11),
        BackgroundColor3=BG1,BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=parent})
    corner(bg,UDim.new(1,0)); bstroke(bg,BDR,1)
    local knob=mk("Frame",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,3,0.5,-8),
        BackgroundColor3=TM,BorderSizePixel=0,Parent=bg})
    corner(knob,UDim.new(1,0))
    return bg, knob
end
local function setSw(bg, knob, on)
    if on then
        tw(bg,{BackgroundColor3=BG3}); tw(knob,{Position=UDim2.new(1,-19,0.5,-8),BackgroundColor3=TW})
    else
        tw(bg,{BackgroundColor3=BG1}); tw(knob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=TM})
    end
end

-- SCREENGUI + WINDOW ───────────────────────────────────────────────────────
local ScreenGui = mk("ScreenGui",{Name="ApexHub",ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=LocalPlayer:WaitForChild("PlayerGui")})

local cam = workspace.CurrentCamera or workspace:WaitForChild("Camera",5)
local vp  = cam and cam.ViewportSize or Vector2.new(1920,1080)
if vp.X < 640 then GUI_W=math.min(vp.X-20,500); GUI_H=math.min(vp.Y-40,580); SB_W=118 end

local Window = mk("Frame",{Name="ApexWindow",Size=UDim2.new(0,GUI_W,0,GUI_H),
    Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2),
    BackgroundColor3=BG0,BorderSizePixel=0,ClipsDescendants=true,Parent=ScreenGui})
corner(Window,UDim.new(0,14)); bstroke(Window,BDR,1.2)

-- Top accent line
mk("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=AC,BorderSizePixel=0,ZIndex=5,Parent=Window})

-- TITLEBAR ─────────────────────────────────────────────────────────────────
local TitleBar = mk("Frame",{Size=UDim2.new(1,0,0,TB_H),BackgroundColor3=BG1,BorderSizePixel=0,Parent=Window})
hdiv(TitleBar).Position = UDim2.new(0,0,1,-1)

-- Logo box with game icon
local logoBox = mk("Frame",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(0,12,0.5,-14),
    BackgroundColor3=BG3,BorderSizePixel=0,Parent=TitleBar})
corner(logoBox,UDim.new(0,7)); bstroke(logoBox,BDR,1)
local logoIcon = lbl(logoBox,cfg.icon,11,TW,true)
logoIcon.TextXAlignment = Enum.TextXAlignment.Center

-- Hub name
local hubName = lbl(TitleBar,"Apex",16,TW,true)
hubName.Size=UDim2.new(0,50,1,0); hubName.Position=UDim2.new(0,48,0,0)

-- Game label pill
local gamePill = mk("Frame",{Size=UDim2.new(0,0,0,20),Position=UDim2.new(0,102,0.5,-10),
    BackgroundColor3=BG3,BorderSizePixel=0,AutomaticSize=Enum.AutomaticSize.X,Parent=TitleBar})
corner(gamePill,UDim.new(1,0)); bstroke(gamePill,BDR,1)
mk("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),Parent=gamePill})
local gameLabel = lbl(gamePill,cfg.label,10,TM,false)
gameLabel.Size=UDim2.new(0,0,1,0); gameLabel.AutomaticSize=Enum.AutomaticSize.X

-- Version
local verLbl = lbl(TitleBar,"Universal Hub",10,Color3.fromRGB(50,50,65),false)
verLbl.Size=UDim2.new(0,100,1,0); verLbl.Position=UDim2.new(0,220,0,0)

-- Traffic lights
local tlF=mk("Frame",{Size=UDim2.new(0,52,0,12),Position=UDim2.new(1,-66,0.5,-6),
    BackgroundTransparency=1,Parent=TitleBar})
local tlBtns={}
for i,c in ipairs({Color3.fromRGB(255,96,92),Color3.fromRGB(255,189,68),Color3.fromRGB(40,200,64)}) do
    local d=mk("TextButton",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(0,(i-1)*20,0,0),
        BackgroundColor3=c,BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=tlF})
    corner(d,UDim.new(1,0))
    d.MouseEnter:Connect(function() tw(d,{BackgroundTransparency=0.3}) end)
    d.MouseLeave:Connect(function() tw(d,{BackgroundTransparency=0}) end)
    tlBtns[i]=d
end

-- Drag
do
    local drg,ds,sp
    TitleBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drg=true; ds=i.Position; sp=Window.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            Window.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

-- BODY ─────────────────────────────────────────────────────────────────────
local Body=mk("Frame",{Size=UDim2.new(1,0,1,-TB_H),Position=UDim2.new(0,0,0,TB_H),BackgroundTransparency=1,Parent=Window})

-- SIDEBAR ──────────────────────────────────────────────────────────────────
local Sidebar=mk("Frame",{Size=UDim2.new(0,SB_W,1,0),BackgroundColor3=BG1,BorderSizePixel=0,Parent=Body})
mk("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=BDR,BorderSizePixel=0,Parent=Sidebar})

-- Game badge at bottom of sidebar
local sbBadge=mk("Frame",{Size=UDim2.new(1,-16,0,40),Position=UDim2.new(0,8,1,-52),
    BackgroundColor3=BG3,BorderSizePixel=0,Parent=Sidebar})
corner(sbBadge,UDim.new(0,8)); bstroke(sbBadge,BDR,1)
local badgeIcon=lbl(sbBadge,cfg.icon,13,TW,true)
badgeIcon.Size=UDim2.new(0,28,1,0); badgeIcon.Position=UDim2.new(0,8,0,0); badgeIcon.TextXAlignment=Enum.TextXAlignment.Center
local badgeLbl=lbl(sbBadge,cfg.label,10,TM,false)
badgeLbl.Size=UDim2.new(1,-42,1,0); badgeLbl.Position=UDim2.new(0,40,0,0)

-- CONTENT ──────────────────────────────────────────────────────────────────
local Content=mk("Frame",{Size=UDim2.new(1,-SB_W,1,0),Position=UDim2.new(0,SB_W,0,0),
    BackgroundTransparency=1,ClipsDescendants=true,Parent=Body})

-- Player card
local pc=mk("Frame",{Size=UDim2.new(0,144,0,34),Position=UDim2.new(1,-152,0,7),
    BackgroundColor3=BG2,BorderSizePixel=0,ZIndex=5,Parent=Content})
corner(pc,UDim.new(0,8)); bstroke(pc,BDR,1)
local av=mk("ImageLabel",{Size=UDim2.new(0,24,0,24),Position=UDim2.new(0,5,0.5,-12),
    BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=6,Parent=pc}); corner(av,UDim.new(1,0))
local un=lbl(pc,"...",11,TW,true)
un.Size=UDim2.new(1,-36,1,0); un.Position=UDim2.new(0,34,0,0); un.ZIndex=6
un.TextTruncate=Enum.TextTruncate.AtEnd
task.spawn(function()
    un.Text=LocalPlayer.Name
    av.Image=Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
end)

-- PAGE SYSTEM ──────────────────────────────────────────────────────────────
local allPages={}
local function makePage()
    local p=mk("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,Parent=Content})
    table.insert(allPages,p); return p
end
local function makeScrollPage()
    local p=makePage()
    local s=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=isMobile and 0 or 2,ScrollBarImageColor3=AC2,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingEnabled=true,ScrollingDirection=Enum.ScrollingDirection.Y,Parent=p})
    mk("UIListLayout",{Padding=UDim.new(0,0),Parent=s})
    return p, s
end
local function showPage(page)
    for _,p in ipairs(allPages) do p.Visible=false end
    page.Visible=true
end

-- UI COMPONENTS ─────────────────────────────────────────────────────────────
local function secHdr(scroll, title)
    local h=mk("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=BG1,BorderSizePixel=0,Parent=scroll})
    local bar=mk("Frame",{Size=UDim2.new(0,2,0.55,0),Position=UDim2.new(0,0,0.225,0),BackgroundColor3=AC,BorderSizePixel=0,Parent=h})
    corner(bar,UDim.new(0,2))
    local l=lbl(h,title,10,AC2,true); l.Size=UDim2.new(1,-14,1,0); l.Position=UDim2.new(0,12,0,0)
    hdiv(h).Position=UDim2.new(0,0,1,-1)
end

local function toggleRow(scroll, text)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,isMobile and 52 or 44),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local l=lbl(row,text,13,TW); l.Size=UDim2.new(0.65,-16,1,0); l.Position=UDim2.new(0,16,0,0)
    local bg,knob=makeSwitch(row); hdiv(row).Position=UDim2.new(0,0,1,-1)
    return row,bg,knob
end

local allDrags={}
local function makeSlider(scroll, text, mn, mx, sv, step, onChange)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,56),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local nl=lbl(row,text,12,TW); nl.Size=UDim2.new(0.55,-16,0,18); nl.Position=UDim2.new(0,16,0,7)
    local vl=lbl(row,tostring(sv),12,AC,true); vl.Size=UDim2.new(0,50,0,18); vl.Position=UDim2.new(1,-58,0,7); vl.TextXAlignment=Enum.TextXAlignment.Right
    local tr=mk("TextButton",{Size=UDim2.new(1,-32,0,4),Position=UDim2.new(0,16,0,36),BackgroundColor3=BG3,BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=row})
    corner(tr,UDim.new(1,0))
    local fi=mk("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=AC2,BorderSizePixel=0,Parent=tr}); corner(fi,UDim.new(1,0))
    local th=mk("TextButton",{Size=UDim2.new(0,11,0,11),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),
        BackgroundColor3=TW,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=3,Parent=tr})
    corner(th,UDim.new(1,0)); hdiv(row).Position=UDim2.new(0,0,1,-1)
    local cur=sv
    local function set(v)
        if step then v=math.round(v/step)*step end
        v=math.clamp(v,mn,mx); cur=v; vl.Text=tostring(v)
        local pct=(v-mn)/(mx-mn); local tw2=tr.AbsoluteSize.X
        fi.Size=UDim2.new(0,tw2*pct,1,0); th.Position=UDim2.new(0,tw2*pct,0.5,0)
        if onChange then onChange(v) end
    end
    local function inp(x) local pct=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1); set(mn+pct*(mx-mn)) end
    task.defer(function() set(sv) end)
    local de={isDragging=false,onInput=inp}
    tr.InputBegan:Connect(function(i) if isClick(i.UserInputType) then de.isDragging=true; inp(i.Position.X) end end)
    th.InputBegan:Connect(function(i) if isClick(i.UserInputType) then de.isDragging=true end end)
    table.insert(allDrags,de)
    return row, function() return cur end
end

local function applyRow(scroll, text, onPress)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local l=lbl(row,text,13,TW); l.Size=UDim2.new(0.6,-16,1,0); l.Position=UDim2.new(0,16,0,0)
    local btn=mk("TextButton",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-112,0.5,-14),
        BackgroundColor3=BG3,BorderSizePixel=0,Text="APPLY",TextColor3=AC2,TextSize=11,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=row})
    corner(btn,UDim.new(0,7)); bstroke(btn,BDR,1); hdiv(row).Position=UDim2.new(0,0,1,-1)
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=BG2}) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=BG3}) end)
    btn.MouseButton1Click:Connect(function() onPress(btn) end)
    return btn
end

local function inputRow(scroll, ph, onSubmit)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local box=mk("TextBox",{Size=UDim2.new(1,-116,0,26),Position=UDim2.new(0,16,0,9),BackgroundColor3=BG3,BorderSizePixel=0,
        PlaceholderText=ph or "",PlaceholderColor3=TM,Text="",TextColor3=TW,TextSize=12,Font=Enum.Font.Gotham,ClearTextOnFocus=false,Parent=row})
    corner(box,UDim.new(0,6)); bstroke(box,BDR,1)
    local sub=mk("TextButton",{Size=UDim2.new(0,86,0,26),Position=UDim2.new(1,-102,0,9),BackgroundColor3=BG3,BorderSizePixel=0,
        Text="APPLY",TextColor3=AC2,TextSize=11,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=row})
    corner(sub,UDim.new(0,6)); bstroke(sub,BDR,1); hdiv(row).Position=UDim2.new(0,0,1,-1)
    sub.MouseEnter:Connect(function() tw(sub,{BackgroundColor3=BG2}) end)
    sub.MouseLeave:Connect(function() tw(sub,{BackgroundColor3=BG3}) end)
    sub.MouseButton1Click:Connect(function()
        local num=tonumber(box.Text)
        if not num then sub.Text="BAD"; sub.TextColor3=RED; task.delay(1.5,function() sub.Text="APPLY"; sub.TextColor3=AC2 end); return end
        onSubmit(num); sub.Text="DONE"; sub.TextColor3=GREEN; task.delay(1.5,function() sub.Text="APPLY"; sub.TextColor3=AC2 end)
    end)
end

-- NOTIFICATION ─────────────────────────────────────────────────────────────
local function notif(title, msg, col)
    col=col or AC
    local n=mk("Frame",{Size=UDim2.new(0,215,0,50),Position=UDim2.new(1,10,1,-68),AnchorPoint=Vector2.new(1,1),
        BackgroundColor3=BG2,BorderSizePixel=0,ZIndex=50,Parent=ScreenGui})
    corner(n,UDim.new(0,8)); bstroke(n,BDR,1)
    mk("Frame",{Size=UDim2.new(0,2,1,-10),Position=UDim2.new(0,7,0,5),BackgroundColor3=col,BorderSizePixel=0,ZIndex=51,Parent=n})
    local tl=mk("TextLabel",{Size=UDim2.new(1,-18,0,16),Position=UDim2.new(0,16,0,7),BackgroundTransparency=1,
        Text=title,TextColor3=TW,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=n})
    local ml=mk("TextLabel",{Size=UDim2.new(1,-18,0,14),Position=UDim2.new(0,16,0,25),BackgroundTransparency=1,
        Text=msg,TextColor3=TM,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=n})
    TweenService:Create(n,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(1,-12,1,-68)}):Play()
    task.delay(2.8,function()
        TweenService:Create(n,TweenInfo.new(0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(1,10,1,-68)}):Play()
        task.delay(0.2,function() n:Destroy() end)
    end)
end

-- HOME PAGE ─────────────────────────────────────────────────────────────────
local HomePage, HomeScroll = makeScrollPage()
do
    -- Hero block
    local hero=mk("Frame",{Size=UDim2.new(1,0,0,110),BackgroundTransparency=1,BorderSizePixel=0,Parent=HomeScroll})
    local heroCard=mk("Frame",{Size=UDim2.new(1,-24,0,90),Position=UDim2.new(0,12,0,10),BackgroundColor3=BG1,BorderSizePixel=0,Parent=hero})
    corner(heroCard,UDim.new(0,12)); bstroke(heroCard,BDR,1)
    -- Accent strip on left
    local heroBar=mk("Frame",{Size=UDim2.new(0,4,1,0),BackgroundColor3=AC,BorderSizePixel=0,Parent=heroCard}); corner(heroBar,UDim.new(0,4))
    -- Icon
    local heroIcon=mk("Frame",{Size=UDim2.new(0,48,0,48),Position=UDim2.new(0,18,0.5,-24),BackgroundColor3=BG3,BorderSizePixel=0,Parent=heroCard})
    corner(heroIcon,UDim.new(0,10)); bstroke(heroIcon,BDR,1)
    local hIcoLbl=lbl(heroIcon,cfg.icon,18,TW,true); hIcoLbl.TextXAlignment=Enum.TextXAlignment.Center
    -- Text
    local hTitle=mk("TextLabel",{Size=UDim2.new(1,-82,0,22),Position=UDim2.new(0,78,0,18),BackgroundTransparency=1,
        Text="Apex Hub",TextColor3=TW,TextSize=16,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=heroCard})
    local hSub=mk("TextLabel",{Size=UDim2.new(1,-82,0,16),Position=UDim2.new(0,78,0,42),BackgroundTransparency=1,
        Text="Universal Game Hub",TextColor3=TM,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=heroCard})
    local hGame=mk("TextLabel",{Size=UDim2.new(1,-82,0,16),Position=UDim2.new(0,78,0,60),BackgroundTransparency=1,
        Text="Detected: "..cfg.label,TextColor3=AC2,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=heroCard})

    -- Status rows
    local statusData={
        {"Anti-Cheat Bypass","Auto-applied on load",GREEN},
        {"Webhook",          "Reporting to Discord", AC2},
        {"Hub Version",      "Apex v1.0",            TM},
    }
    for _,sd in ipairs(statusData) do
        local row=mk("Frame",{Size=UDim2.new(1,0,0,50),BackgroundTransparency=1,BorderSizePixel=0,Parent=HomeScroll})
        local card=mk("Frame",{Size=UDim2.new(1,-24,0,40),Position=UDim2.new(0,12,0,5),BackgroundColor3=BG1,BorderSizePixel=0,Parent=row})
        corner(card,UDim.new(0,8)); bstroke(card,BDR,1)
        local dot=mk("Frame",{Size=UDim2.new(0,6,0,6),Position=UDim2.new(0,12,0.5,-3),BackgroundColor3=sd[3],BorderSizePixel=0,Parent=card}); corner(dot,UDim.new(1,0))
        local t1=lbl(card,sd[1],12,TW,true); t1.Size=UDim2.new(0.5,0,1,0); t1.Position=UDim2.new(0,26,0,0)
        local t2=lbl(card,sd[2],10,TM);      t2.Size=UDim2.new(0.5,-8,1,0); t2.Position=UDim2.new(0.5,0,0,0)
    end

    -- Footer
    local foot=mk("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,BorderSizePixel=0,Parent=HomeScroll})
    local fl=lbl(foot,"Press K to toggle  |  Universal Hub  |  Apex",10,Color3.fromRGB(40,40,55))
    fl.Size=UDim2.new(1,-32,1,0); fl.Position=UDim2.new(0,16,0,0); fl.TextXAlignment=Enum.TextXAlignment.Center
end

-- NAV SYSTEM ────────────────────────────────────────────────────────────────
local navBtnRefs = {}
local _navOrder  = 0

local sbList = mk("Frame",{Size=UDim2.new(1,0,1,-52),BackgroundTransparency=1,BorderSizePixel=0,Parent=Sidebar})
mk("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,Parent=sbList})

-- top spacer
_navOrder=_navOrder+1
mk("Frame",{Size=UDim2.new(1,0,0,8),LayoutOrder=_navOrder,BackgroundTransparency=1,BorderSizePixel=0,Parent=sbList})

local function makeNavBtn(labelTxt, icon)
    _navOrder=_navOrder+1
    local wrap=mk("Frame",{Size=UDim2.new(1,0,0,40),LayoutOrder=_navOrder,BackgroundTransparency=1,BorderSizePixel=0,Parent=sbList})
    local btn=mk("TextButton",{Size=UDim2.new(1,-10,0,34),Position=UDim2.new(0,5,0,3),
        BackgroundColor3=BG2,BackgroundTransparency=1,BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=wrap})
    corner(btn,UDim.new(0,8))
    local bar=mk("Frame",{Size=UDim2.new(0,2,0.55,0),Position=UDim2.new(0,0,0.225,0),BackgroundColor3=AC,BorderSizePixel=0,Visible=false,Parent=btn}); corner(bar,UDim.new(0,2))
    local ico=lbl(btn,icon,10,TM,true); ico.Size=UDim2.new(0,22,1,0); ico.Position=UDim2.new(0,8,0,0); ico.TextXAlignment=Enum.TextXAlignment.Center
    local nam=lbl(btn,labelTxt,11,TM); nam.Size=UDim2.new(1,-34,1,0); nam.Position=UDim2.new(0,32,0,0)
    btn.MouseEnter:Connect(function() if btn.BackgroundTransparency~=0 then tw(btn,{BackgroundTransparency=0.6,BackgroundColor3=BG2}) end end)
    btn.MouseLeave:Connect(function() if btn.BackgroundTransparency~=0 then tw(btn,{BackgroundTransparency=1}) end end)
    local ref={btn=btn,bar=bar,ico=ico,nam=nam}; table.insert(navBtnRefs,ref); return ref
end

local function deactivateAllNav()
    for _,r in ipairs(navBtnRefs) do
        tw(r.btn,{BackgroundColor3=BG2,BackgroundTransparency=1})
        r.bar.Visible=false; r.ico.TextColor3=TM; r.nam.TextColor3=TM; r.nam.Font=Enum.Font.Gotham
    end
    for _,p in ipairs(allPages) do p.Visible=false end
end
local function activateNav(ref)
    deactivateAllNav()
    tw(ref.btn,{BackgroundColor3=BG2,BackgroundTransparency=0})
    ref.bar.Visible=true; ref.ico.TextColor3=AC; ref.nam.TextColor3=TW; ref.nam.Font=Enum.Font.GothamBold
end

-- HOME nav button
local homeRef = makeNavBtn("Home","H")

-- RCFA dropdown support
local rcfaRef       = nil
local rcfaDrop      = nil
local rcfaSubRefs   = {}
local rcfaOpen      = false
local rcfaArrow     = nil
local RCFA_H        = 0

local function setDropOpen(open)
    if not rcfaDrop then return end
    rcfaOpen=open
    TweenService:Create(rcfaDrop,TweenInfo.new(0.2,Enum.EasingStyle.Quint,
        open and Enum.EasingDirection.Out or Enum.EasingDirection.In),
        {Size=UDim2.new(1,0,0,open and RCFA_H or 0)}):Play()
    if rcfaArrow then tw(rcfaArrow,{TextColor3=open and AC or TM}) end
    if rcfaArrow then rcfaArrow.Text=open and "^" or "v" end
end

local function activateRCFASub(ref)
    for _,s in ipairs(rcfaSubRefs) do
        s.dot.BackgroundColor3=TM; s.ico.TextColor3=TM; s.nam.TextColor3=TM; s.nam.Font=Enum.Font.Gotham
        tw(s.btn,{BackgroundColor3=BG3,BackgroundTransparency=1})
    end
    ref.dot.BackgroundColor3=AC; ref.ico.TextColor3=AC; ref.nam.TextColor3=TW; ref.nam.Font=Enum.Font.GothamBold
    tw(ref.btn,{BackgroundColor3=BG3,BackgroundTransparency=0})
    showPage(ref.page)
end

-- Functions the features script calls to build nav
local function addRCFANav(subPages)
    rcfaRef = makeNavBtn("RCFA","RF")
    rcfaArrow=mk("TextLabel",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(1,-18,0.5,-7),
        BackgroundTransparency=1,Text="v",TextColor3=TM,TextSize=10,Font=Enum.Font.GothamBold,Parent=rcfaRef.btn})
    _navOrder=_navOrder+1
    rcfaDrop=mk("Frame",{Size=UDim2.new(1,0,0,0),LayoutOrder=_navOrder,BackgroundColor3=Color3.fromRGB(8,10,16),BorderSizePixel=0,ClipsDescendants=true,Parent=sbList})
    corner(rcfaDrop,UDim.new(0,6))
    mk("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,4),Parent=rcfaDrop})
    mk("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,Parent=rcfaDrop})
    RCFA_H = #subPages * 30 + 14
    for i,def in ipairs(subPages) do
        local sbtn=mk("TextButton",{Size=UDim2.new(1,0,0,28),LayoutOrder=i,BackgroundColor3=BG3,BackgroundTransparency=1,BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=rcfaDrop})
        corner(sbtn,UDim.new(0,6))
        local dot=mk("Frame",{Size=UDim2.new(0,4,0,4),Position=UDim2.new(0,4,0.5,-2),BackgroundColor3=TM,BorderSizePixel=0,Parent=sbtn}); corner(dot,UDim.new(1,0))
        local sico=lbl(sbtn,def.icon,9,TM,true); sico.Size=UDim2.new(0,18,1,0); sico.Position=UDim2.new(0,12,0,0); sico.TextXAlignment=Enum.TextXAlignment.Center
        local snam=lbl(sbtn,def.label,10,TM); snam.Size=UDim2.new(1,-34,1,0); snam.Position=UDim2.new(0,32,0,0)
        sbtn.MouseEnter:Connect(function() if sbtn.BackgroundTransparency~=0 then tw(sbtn,{BackgroundTransparency=0.5,BackgroundColor3=BG3}) end end)
        sbtn.MouseLeave:Connect(function() if sbtn.BackgroundTransparency~=0 then tw(sbtn,{BackgroundTransparency=1}) end end)
        local sref={btn=sbtn,dot=dot,ico=sico,nam=snam,page=def.page}
        table.insert(rcfaSubRefs,sref)
        sbtn.MouseButton1Click:Connect(function() activateNav(rcfaRef); activateRCFASub(sref) end)
    end
    rcfaRef.btn.MouseButton1Click:Connect(function()
        activateNav(rcfaRef)
        if rcfaOpen then setDropOpen(false)
        else setDropOpen(true); if rcfaSubRefs[1] then activateRCFASub(rcfaSubRefs[1]) end end
    end)
end

local function addSimpleNav(labelTxt, icon, page)
    _navOrder=_navOrder+1
    local ref=makeNavBtn(labelTxt,icon)
    ref.btn.MouseButton1Click:Connect(function()
        activateNav(ref); setDropOpen(false); showPage(page)
    end)
    return ref
end

-- bottom spacer placeholder (added after features script builds nav)
local function finalizeNav()
    _navOrder=_navOrder+1
    mk("Frame",{Size=UDim2.new(1,0,0,8),LayoutOrder=_navOrder,BackgroundTransparency=1,BorderSizePixel=0,Parent=sbList})
    -- activate home by default
    activateNav(homeRef); showPage(HomePage)
end

homeRef.btn.MouseButton1Click:Connect(function()
    activateNav(homeRef); setDropOpen(false); showPage(HomePage)
end)

-- TITLE BAR CONTROLS ────────────────────────────────────────────────────────
local nSize=UDim2.new(0,GUI_W,0,GUI_H); local nPos=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2)
local isFS=false; local guiOpen=true
local function setVis(v)
    guiOpen=v
    if v then
        Window.Visible=true
        TweenService:Create(Window,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=0,Position=nPos}):Play()
    else
        TweenService:Create(Window,TweenInfo.new(0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{BackgroundTransparency=1,Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2+12)}):Play()
        task.delay(0.2,function() if not guiOpen then Window.Visible=false end end)
    end
end
tlBtns[1].MouseButton1Click:Connect(function()
    TweenService:Create(Window,TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{BackgroundTransparency=1,Size=UDim2.new(0,GUI_W*0.93,0,GUI_H*0.93),Position=UDim2.new(0.5,-(GUI_W*0.93)/2,0.5,-(GUI_H*0.93)/2)}):Play()
    task.delay(0.17,function() ScreenGui:Destroy() end)
end)
tlBtns[2].MouseButton1Click:Connect(function() setVis(false) end)
tlBtns[3].MouseButton1Click:Connect(function()
    if isFS then isFS=false
        TweenService:Create(Window,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=nSize,Position=nPos}):Play()
        task.delay(0.01,function() corner(Window,UDim.new(0,14)) end)
    else isFS=true; nPos=Window.Position; nSize=Window.Size
        for _,c in ipairs(Window:GetChildren()) do if c:IsA("UICorner") then c:Destroy() end end
        TweenService:Create(Window,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0)}):Play()
    end
end)

UserInputService.InputBegan:Connect(function(i,proc)
    if proc then return end
    if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==toggleKey then setVis(not guiOpen) end
end)

-- Slider input global
UserInputService.InputEnded:Connect(function(i)
    if isClick(i.UserInputType) then for _,d in ipairs(allDrags) do d.isDragging=false end end
end)
UserInputService.InputChanged:Connect(function(i)
    if not isMove(i.UserInputType) then return end
    for _,d in ipairs(allDrags) do if d.isDragging then d.onInput(i.Position.X) end end
end)

-- Mobile button
local mob=mk("TextButton",{Size=UDim2.new(0,42,0,42),Position=UDim2.new(0,8,0.5,-21),BackgroundColor3=BG2,BorderSizePixel=0,
    Text="A",TextColor3=TW,TextSize=16,Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=20,Visible=isMobile,Parent=ScreenGui})
corner(mob,UDim.new(1,0)); bstroke(mob,BDR,1)
mob.MouseButton1Click:Connect(function() setVis(not guiOpen) end)
mob.TouchTap:Connect(function() setVis(not guiOpen) end)

-- Animate in
Window.BackgroundTransparency=1; Window.Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2+16)
TweenService:Create(Window,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=0,Position=nPos}):Play()

-- RETURN API ────────────────────────────────────────────────────────────────
return {
    -- Notification
    notif          = notif,
    -- Page builders
    makeScrollPage = makeScrollPage,
    showPage       = showPage,
    -- UI components
    secHdr         = secHdr,
    toggleRow      = toggleRow,
    makeSlider     = makeSlider,
    applyRow       = applyRow,
    inputRow       = inputRow,
    setSw          = setSw,
    -- Nav builders
    addRCFANav     = addRCFANav,
    addSimpleNav   = addSimpleNav,
    finalizeNav    = finalizeNav,
    -- Refs
    ScreenGui      = ScreenGui,
    setVis         = setVis,
    -- Toggle key setter
    setToggleKey   = function(k) toggleKey=k end,
    -- Colors (for features script to use)
    GREEN = GREEN, RED = RED, AC = AC, AC2 = AC2, TW = TW, TM = TM,
}

end

return ApexUI
