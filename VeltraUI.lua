-- ///////////////////////////////////////////////
-- // VeltraUI.lua  -  UI Library
-- // Paste on a raw host (e.g. Pastebin / GitHub raw)
-- // then loadstring() it from your features script
-- ///////////////////////////////////////////////

local function VeltraUI(LocalPlayer, Players, RunService)

-- SERVICES
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- PALETTE  (blue & black)
local A1      = Color3.fromRGB( 50, 130, 255)   -- main blue
local A2      = Color3.fromRGB( 30,  80, 180)   -- deep blue
local A3      = Color3.fromRGB( 80, 160, 255)   -- light blue (hover)
local BG0     = Color3.fromRGB(  6,   8,  14)   -- true black-blue
local BG1     = Color3.fromRGB( 10,  14,  24)   -- dark panel
local BG2     = Color3.fromRGB( 14,  20,  36)   -- mid panel
local BG3     = Color3.fromRGB( 18,  26,  46)   -- card bg
local BDR     = Color3.fromRGB( 28,  44,  90)   -- border
local TW      = Color3.fromRGB(220, 232, 255)    -- white-blue text
local TM      = Color3.fromRGB( 80, 110, 170)   -- muted text
local DIV     = Color3.fromRGB( 16,  26,  50)   -- divider

local GUI_W   = 680
local GUI_H   = 490
local SB_W    = 148     -- sidebar width
local TB_H    = 44      -- titlebar height
local toggleKey = Enum.KeyCode.K
local isMobile  = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- UI HELPERS
local function mk(class, props)
    local i = Instance.new(class)
    for k,v in pairs(props or {}) do i[k]=v end
    return i
end
local function corner(p, r) local c=Instance.new("UICorner"); c.CornerRadius=r or UDim.new(0,8); c.Parent=p end
local function bstroke(p, col, t) local s=Instance.new("UIStroke"); s.Color=col or BDR; s.Thickness=t or 1; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p end
local function lbl(p, text, sz, col, bold)
    local l=mk("TextLabel",{Text=text,TextSize=sz or 13,TextColor3=col or TW,
        Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,
        Size=UDim2.new(1,0,1,0),Parent=p})
    return l
end
local function hdiv(p)
    local d=mk("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=DIV,BorderSizePixel=0,Parent=p})
    return d
end
local function tw(inst, props, t)
    TweenService:Create(inst, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quint), props):Play()
end
local function isClick(t) return t==Enum.UserInputType.MouseButton1 or t==Enum.UserInputType.Touch end
local function isMove(t)  return t==Enum.UserInputType.MouseMovement or t==Enum.UserInputType.Touch end

-- TOGGLE SWITCH
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
        tw(bg,{BackgroundColor3=A2}); tw(knob,{Position=UDim2.new(1,-19,0.5,-8),BackgroundColor3=A1})
    else
        tw(bg,{BackgroundColor3=BG1}); tw(knob,{Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=TM})
    end
end

-- SCREENGUI
local ScreenGui = mk("ScreenGui",{Name="ScreenGui",ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local cam = workspace.CurrentCamera or workspace:WaitForChild("Camera",5)
local vp  = cam and cam.ViewportSize or Vector2.new(1920,1080)
if vp.X < 600 then GUI_W=math.min(vp.X-20,480); GUI_H=math.min(vp.Y-40,560); SB_W=110 end

-- WINDOW
local Window = mk("Frame",{Name="Window",Size=UDim2.new(0,GUI_W,0,GUI_H),
    Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2),
    BackgroundColor3=BG0,BorderSizePixel=0,ClipsDescendants=true,Parent=ScreenGui})
corner(Window,UDim.new(0,14)); bstroke(Window,A2,1.5)
mk("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=A1,BorderSizePixel=0,ZIndex=5,Parent=Window})

-- TITLEBAR
local TitleBar = mk("Frame",{Size=UDim2.new(1,0,0,TB_H),BackgroundColor3=BG1,BorderSizePixel=0,Parent=Window})
hdiv(TitleBar).Position = UDim2.new(0,0,1,-1)

local logoF = mk("Frame",{Size=UDim2.new(0,24,0,24),Position=UDim2.new(0,12,0.5,-12),
    BackgroundColor3=A2,BorderSizePixel=0,Parent=TitleBar})
corner(logoF,UDim.new(0,6))
local ll=lbl(logoF,"V",12,TW,true); ll.TextXAlignment=Enum.TextXAlignment.Center

lbl(TitleBar,"Voltz",15,TW,true).Size=UDim2.new(0,55,1,0); do
    local t=TitleBar:FindFirstChildOfClass("TextLabel"); if t then t.Position=UDim2.new(0,44,0,0) end
end
local sub=lbl(TitleBar,"Rofootball",10,TM); sub.Size=UDim2.new(0,72,1,0); sub.Position=UDim2.new(0,101,0,0)
local vt=lbl(TitleBar,"v"..VERSION,10,Color3.fromRGB(30,60,140)); vt.Size=UDim2.new(0,36,1,0); vt.Position=UDim2.new(0,175,0,0)

-- Traffic lights
local tlF=mk("Frame",{Size=UDim2.new(0,52,0,12),Position=UDim2.new(1,-66,0.5,-6),BackgroundTransparency=1,Parent=TitleBar})
local tlBtns={}
for i,c in ipairs({Color3.fromRGB(255,96,92),Color3.fromRGB(255,189,68),Color3.fromRGB(40,200,64)}) do
    local d=mk("TextButton",{Size=UDim2.new(0,12,0,12),Position=UDim2.new(0,(i-1)*20,0,0),
        BackgroundColor3=c,BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=tlF})
    corner(d,UDim.new(1,0))
    d.MouseEnter:Connect(function() tw(d,{BackgroundTransparency=0.3}) end)
    d.MouseLeave:Connect(function() tw(d,{BackgroundTransparency=0}) end)
    tlBtns[i]=d
end

-- DRAG
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

-- BODY
local Body=mk("Frame",{Size=UDim2.new(1,0,1,-TB_H),Position=UDim2.new(0,0,0,TB_H),BackgroundTransparency=1,Parent=Window})

-- SIDEBAR
local Sidebar=mk("Frame",{Size=UDim2.new(0,SB_W,1,0),BackgroundColor3=BG1,BorderSizePixel=0,Parent=Body})
mk("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=BDR,BorderSizePixel=0,Parent=Sidebar})

-- CONTENT
local Content=mk("Frame",{Size=UDim2.new(1,-SB_W,1,0),Position=UDim2.new(0,SB_W,0,0),
    BackgroundTransparency=1,ClipsDescendants=true,Parent=Body})

-- PLAYER CARD (top right of content)
local pc=mk("Frame",{Size=UDim2.new(0,140,0,34),Position=UDim2.new(1,-148,0,7),
    BackgroundColor3=BG2,BorderSizePixel=0,ZIndex=5,Parent=Content})
corner(pc,UDim.new(0,8)); bstroke(pc,BDR,1)
local av=mk("ImageLabel",{Size=UDim2.new(0,24,0,24),Position=UDim2.new(0,5,0.5,-12),
    BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=6,Parent=pc}); corner(av,UDim.new(1,0))
local un=lbl(pc,"...",11,TW,true)
un.Size=UDim2.new(1,-36,1,0); un.Position=UDim2.new(0,34,0,0); un.TextTruncate=Enum.TextTruncate.AtEnd; un.ZIndex=6
task.spawn(function()
    un.Text=LocalPlayer.Name
    av.Image=Players:GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
end)

-- PAGE SYSTEM
local allPages={}
local function makePage()
    local p=mk("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,Parent=Content})
    table.insert(allPages,p); return p
end
local function makeScrollPage()
    local p=makePage()
    local s=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=isMobile and 0 or 2,ScrollBarImageColor3=A1,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingEnabled=true,ScrollingDirection=Enum.ScrollingDirection.Y,Parent=p})
    mk("UIListLayout",{Padding=UDim.new(0,0),Parent=s})
    return p, s
end
local function showPage(page)
    for _,p in ipairs(allPages) do p.Visible=false end
    page.Visible=true
end

-- SECTION HEADER
local function secHdr(scroll, title)
    local h=mk("Frame",{Size=UDim2.new(1,0,0,28),BackgroundColor3=BG1,BorderSizePixel=0,Parent=scroll})
    local bar=mk("Frame",{Size=UDim2.new(0,3,0.6,0),Position=UDim2.new(0,0,0.2,0),BackgroundColor3=A1,BorderSizePixel=0,Parent=h})
    corner(bar,UDim.new(0,2))
    local l=lbl(h,title,10,A1,true); l.Size=UDim2.new(1,-16,1,0); l.Position=UDim2.new(0,14,0,0)
    hdiv(h).Position=UDim2.new(0,0,1,-1)
end

-- TOGGLE ROW
local function toggleRow(scroll, text)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,isMobile and 52 or 44),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local l=lbl(row,text,13,TW); l.Size=UDim2.new(0.65,-16,1,0); l.Position=UDim2.new(0,16,0,0)
    local bg,knob=makeSwitch(row); hdiv(row).Position=UDim2.new(0,0,1,-1)
    return row,bg,knob
end

-- SLIDER
local allDrags={}
local function makeSlider(scroll, text, mn, mx, sv, step, onChange)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,58),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local nl=lbl(row,text,12,TW); nl.Size=UDim2.new(0.55,-16,0,18); nl.Position=UDim2.new(0,16,0,8)
    local vl=lbl(row,tostring(sv),12,A1,true); vl.Size=UDim2.new(0,50,0,18); vl.Position=UDim2.new(1,-58,0,8); vl.TextXAlignment=Enum.TextXAlignment.Right
    local tr=mk("TextButton",{Size=UDim2.new(1,-32,0,4),Position=UDim2.new(0,16,0,38),BackgroundColor3=BG3,BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=row})
    corner(tr,UDim.new(1,0))
    local fi=mk("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=A2,BorderSizePixel=0,Parent=tr}); corner(fi,UDim.new(1,0))
    local th=mk("TextButton",{Size=UDim2.new(0,11,0,11),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=A1,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=3,Parent=tr})
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

-- APPLY BUTTON ROW
local function applyRow(scroll, text, onPress)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local l=lbl(row,text,13,TW); l.Size=UDim2.new(0.6,-16,1,0); l.Position=UDim2.new(0,16,0,0)
    local btn=mk("TextButton",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-112,0.5,-14),
        BackgroundColor3=A2,BorderSizePixel=0,Text="APPLY",TextColor3=TW,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=row})
    corner(btn,UDim.new(0,7)); hdiv(row).Position=UDim2.new(0,0,1,-1)
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=A1}) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=A2}) end)
    btn.MouseButton1Click:Connect(function() onPress(btn) end)
    return btn
end

-- TEXT INPUT ROW
local function inputRow(scroll, ph, onSubmit)
    local row=mk("Frame",{Size=UDim2.new(1,0,0,44),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
    local box=mk("TextBox",{Size=UDim2.new(1,-116,0,26),Position=UDim2.new(0,16,0,9),BackgroundColor3=BG3,BorderSizePixel=0,
        PlaceholderText=ph or "",PlaceholderColor3=TM,Text="",TextColor3=TW,TextSize=12,Font=Enum.Font.Gotham,ClearTextOnFocus=false,Parent=row})
    corner(box,UDim.new(0,6)); bstroke(box,BDR,1)
    local btn=mk("TextButton",{Size=UDim2.new(0,86,0,26),Position=UDim2.new(1,-102,0,9),BackgroundColor3=A2,BorderSizePixel=0,
        Text="APPLY",TextColor3=TW,TextSize=11,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=row})
    corner(btn,UDim.new(0,6)); hdiv(row).Position=UDim2.new(0,0,1,-1)
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=A1}) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=A2}) end)
    btn.MouseButton1Click:Connect(function()
        local num=tonumber(box.Text)
        if not num then btn.Text="BAD"; btn.BackgroundColor3=Color3.fromRGB(180,50,50)
            task.delay(1.5,function() btn.Text="APPLY"; tw(btn,{BackgroundColor3=A2}) end); return end
        onSubmit(num); btn.Text="DONE"; btn.BackgroundColor3=Color3.fromRGB(30,140,80)
        task.delay(1.5,function() btn.Text="APPLY"; tw(btn,{BackgroundColor3=A2}) end)
    end)
end

-- NOTIFICATION
local function notif(title, msg, col)
    col=col or A1
    local n=mk("Frame",{Size=UDim2.new(0,210,0,48),Position=UDim2.new(1,10,1,-66),AnchorPoint=Vector2.new(1,1),
        BackgroundColor3=BG2,BorderSizePixel=0,ZIndex=50,Parent=ScreenGui})
    corner(n,UDim.new(0,8)); bstroke(n,col,1)
    mk("Frame",{Size=UDim2.new(0,2,1,-10),Position=UDim2.new(0,7,0,5),BackgroundColor3=col,BorderSizePixel=0,ZIndex=51,Parent=n})
    local tl=mk("TextLabel",{Size=UDim2.new(1,-18,0,16),Position=UDim2.new(0,16,0,7),BackgroundTransparency=1,
        Text=title,TextColor3=TW,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=n})
    local ml=mk("TextLabel",{Size=UDim2.new(1,-18,0,14),Position=UDim2.new(0,16,0,24),BackgroundTransparency=1,
        Text=msg,TextColor3=TM,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=n})
    TweenService:Create(n,TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(1,-12,1,-66)}):Play()
    task.delay(2.5,function()
        TweenService:Create(n,TweenInfo.new(0.18,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=UDim2.new(1,10,1,-66)}):Play()
        task.delay(0.2,function() n:Destroy() end)
    end)
end

-- FIRE TO SERVER
local function fire(msg, val)
    pcall(function()
        local c=LocalPlayer.Character; if not c then return end
        local hb=c:FindFirstChild("Hitbox"); if not hb then return end
        local re=hb:FindFirstChild("RemoteEvent"); if not re then return end
        re:FireServer({msg,val})
    end)
end

local qbHUD=mk("Frame",{Size=UDim2.new(0,300,0,38),Position=UDim2.new(0.5,-150,0,6),
    BackgroundColor3=BG1,BorderSizePixel=0,ZIndex=50,Visible=false,Parent=ScreenGui})
corner(qbHUD,UDim.new(0,10)); bstroke(qbHUD,A2,1.2)
local qbDot=mk("Frame",{Size=UDim2.new(0,8,0,8),Position=UDim2.new(0,12,0.5,-4),
    BackgroundColor3=Color3.fromRGB(200,60,60),BorderSizePixel=0,ZIndex=51,Parent=qbHUD})
corner(qbDot,UDim.new(1,0))
local qbHL=mk("TextLabel",{Size=UDim2.new(1,-28,1,0),Position=UDim2.new(0,26,0,0),
    BackgroundTransparency=1,Text="QB Aimbot: Hover over a WR",TextColor3=TM,TextSize=12,
    Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=51,Parent=qbHUD})

-- HOME PAGE
local HomePage, HomeScroll = makeScrollPage()
do
    local hdr=mk("Frame",{Size=UDim2.new(1,0,0,100),BackgroundTransparency=1,BorderSizePixel=0,Parent=HomeScroll})
    local logo=mk("Frame",{Size=UDim2.new(0,52,0,52),Position=UDim2.new(0.5,-26,0,16),BackgroundColor3=A2,BorderSizePixel=0,Parent=hdr})
    corner(logo,UDim.new(0,12)); bstroke(logo,A1,1.5)
    local ll=lbl(logo,"V",24,TW,true); ll.TextXAlignment=Enum.TextXAlignment.Center
    local tl=mk("TextLabel",{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,0,70),
        BackgroundTransparency=1,Text="Veltra  v"..VERSION,TextColor3=TW,TextSize=14,
        Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,Parent=hdr})
    hdiv(hdr).Position=UDim2.new(0,0,1,-1)
    -- Status cards
    local cardData = {
        {"AC Bypass","Auto on load",Color3.fromRGB(40,200,80)},
        {"Webhook","Connected",A1},
        {"Version","v"..VERSION,TM},
    }
    for i, cd in ipairs(cardData) do
        local card=mk("Frame",{Size=UDim2.new(1,-32,0,50),Position=UDim2.new(0,16,0,108+(i-1)*58),
            BackgroundColor3=BG2,BorderSizePixel=0,Parent=HomeScroll})
        corner(card,UDim.new(0,8)); bstroke(card,BDR,1)
        local bar=mk("Frame",{Size=UDim2.new(0,3,0.5,0),Position=UDim2.new(0,0,0.25,0),BackgroundColor3=cd[3],BorderSizePixel=0,Parent=card})
        corner(bar,UDim.new(0,2))
        local t1=lbl(card,cd[1],12,TW,true); t1.Size=UDim2.new(0.5,0,0.5,0); t1.Position=UDim2.new(0,14,0,8)
        local t2=lbl(card,cd[2],11,TM); t2.Size=UDim2.new(0.8,0,0.5,0); t2.Position=UDim2.new(0,14,0.5,-2)
    end
    -- info row at bottom
    local infoRow=mk("Frame",{Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,BorderSizePixel=0,Parent=HomeScroll})
    local il=lbl(infoRow,"Press K to toggle  |  Made by Syphen",11,TM)
    il.Size=UDim2.new(1,-32,1,0); il.Position=UDim2.new(0,16,0,0); il.TextXAlignment=Enum.TextXAlignment.Center
end

-- QB AIMBOT PAGE
local QBPage, QBScroll = makeScrollPage()
do
    secHdr(QBScroll,"QB AIMBOT")
    local qbEnabled=false; local qbLocked=nil; local qbTrack=nil; local qbThrow=nil
    local qbFOV=60; local qbKey=Enum.KeyCode.T; local qbKeyListen=false; local qbMB1=false
    local _,qbBg,qbKnob=toggleRow(QBScroll,"Enable QB Aimbot")
    makeSlider(QBScroll,"Detct Range (studs)",10,200,60,1,function(v) qbFOV=v end)

    -- Throw keybind row
    local bRow=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,BorderSizePixel=0,Parent=QBScroll})
    lbl(bRow,"Throw Keybind",13,TW).Position=UDim2.new(0,16,0,0)
    local bBtn=mk("TextButton",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-112,0.5,-14),
        BackgroundColor3=BG3,BorderSizePixel=0,Text="T",TextColor3=A1,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=bRow})
    corner(bBtn,UDim.new(0,7)); bstroke(bBtn,BDR,1); hdiv(bRow).Position=UDim2.new(0,0,1,-1)

    -- MB1 toggle
    local _,mb1Bg,mb1Knob=toggleRow(QBScroll,"Also Throw on Mouse Click")
    mb1Bg.MouseButton1Click:Connect(function() qbMB1=not qbMB1; setSw(mb1Bg,mb1Knob,qbMB1) end)

    bBtn.MouseButton1Click:Connect(function()
        if qbKeyListen then return end; qbKeyListen=true; bBtn.Text="..."
        local c; c=UserInputService.InputBegan:Connect(function(i,_)
            if i.UserInputType~=Enum.UserInputType.Keyboard then return end
            if i.KeyCode==Enum.KeyCode.Escape then bBtn.Text=qbKey.Name; qbKeyListen=false; c:Disconnect(); return end
            qbKey=i.KeyCode; bBtn.Text=i.KeyCode.Name; qbKeyListen=false; c:Disconnect()
            notif("QB Aimbot","Throw key: "..i.KeyCode.Name,A1)
        end)
    end)

    local function qbPwr(d)
        local t={[10]=20,[15]=30,[20]=35,[25]=42,[30]=48,[35]=52,[40]=58,[45]=65,[50]=70,[55]=78,[60]=85,[65]=90,[70]=95,[76]=99}
        local best,bv=76,99
        for k,v in pairs(t) do if d<=k and k<best then best=k; bv=v end end
        return bv
    end
    local function qbArc(d)
        local t={[10]=6,[15]=10,[20]=12,[25]=15,[30]=17,[35]=19,[40]=22,[45]=26,[50]=30,[55]=38,[60]=45,[65]=50,[70]=55,[76]=62}
        local best,bv=76,62
        for k,v in pairs(t) do if d<=k and k<best then best=k; bv=v end end
        return bv
    end
    local function getHover()
        local m=LocalPlayer:GetMouse(); local tg=m.Target; if not tg then return nil,nil end
        local model=tg; while model and not model:FindFirstChildOfClass("Humanoid") do model=model.Parent end
        if not model then return nil,nil end
        local hum=model:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then return nil,nil end
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character==model then return p,model end
        end
        return nil,nil
    end
    local adjPwr=false
    local function setPwr(tgt)
        if adjPwr then return end; adjPwr=true
        task.spawn(function()
            local char=LocalPlayer.Character; if not char then adjPwr=false; return end
            local ev=char:FindFirstChild("Events"); if not ev then adjPwr=false; return end
            local up=ev:FindFirstChild("PowerUp"); local dn=ev:FindFirstChild("PowerDown")
            local function gp() local pv=char:FindFirstChild("PowerValue"); return pv and pv.Value or 0 end
            local tries=0
            while math.abs(gp()-tgt)>1 and tries<80 do
                if gp()<tgt then pcall(function() if up then up:FireServer() end end)
                else pcall(function() if dn then dn:FireServer() end end) end
                tries=tries+1; task.wait(0.05)
            end
            adjPwr=false
        end)
    end
    local function doThrow()
        if not qbEnabled or not qbLocked or not qbLocked.Parent then return end
        local char=LocalPlayer.Character; if not char then return end
        local fb=char:FindFirstChild("Football"); if not fb then return end
        local h=fb:FindFirstChild("Handle"); if not h then return end
        local re=h:FindFirstChild("RemoteEvent"); if not re then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local ehr=qbLocked:FindFirstChild("HumanoidRootPart")
        if not hrp or not ehr then return end
        local dist=(ehr.Position-hrp.Position).Magnitude
        pcall(function() re:FireServer({"Throw",ehr.Position+Vector3.new(0,qbArc(dist),0)}) end)
        notif("QB Aimbot","Thrown!",A1)
    end
    local function updHUD()
        if not qbEnabled then qbHUD.Visible=false; return end
        qbHUD.Visible=true
        if qbLocked and qbLocked.Parent then
            local ehr=qbLocked:FindFirstChild("HumanoidRootPart")
            local mhr=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local d=ehr and mhr and math.floor((ehr.Position-mhr.Position).Magnitude) or 0
            local nm=""; for _,p in pairs(Players:GetPlayers()) do if p.Character==qbLocked then nm=p.Name; break end end
            qbDot.BackgroundColor3=Color3.fromRGB(40,200,80)
            qbHL.Text="[LOCK] "..nm.."  |  "..d.."st  |  PWR "..qbPwr(d).."%"; qbHL.TextColor3=TW
        else
            qbDot.BackgroundColor3=Color3.fromRGB(200,60,60)
            qbHL.Text="QB Aimbot: Hover over a QB"; qbHL.TextColor3=TM
        end
    end
    local function setQB(on)
        qbEnabled=on; setSw(qbBg,qbKnob,on)
        if on then
            if qbTrack then qbTrack:Disconnect() end
            qbTrack=RunService.Heartbeat:Connect(function()
                if not qbEnabled then return end
                local _,char=getHover()
                if char then
                    local ehr=char:FindFirstChild("HumanoidRootPart")
                    local mhr=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if ehr and mhr and (ehr.Position-mhr.Position).Magnitude<=qbFOV then qbLocked=char end
                end
                if qbLocked then
                    local hum=qbLocked:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health<=0 or not qbLocked.Parent then qbLocked=nil end
                end
                if qbLocked then
                    local ehr=qbLocked:FindFirstChild("HumanoidRootPart")
                    local mhr=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if ehr and mhr then setPwr(qbPwr((ehr.Position-mhr.Position).Magnitude)) end
                end
                updHUD()
            end)
            if qbThrow then qbThrow:Disconnect() end
            qbThrow=UserInputService.InputBegan:Connect(function(i,proc)
                if proc then return end
                if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==qbKey then doThrow()
                elseif qbMB1 and i.UserInputType==Enum.UserInputType.MouseButton1 then doThrow() end
            end)
            notif("QB Aimbot","Enabled - hover over WR, press "..qbKey.Name,A1)
        else
            if qbTrack then qbTrack:Disconnect(); qbTrack=nil end
            if qbThrow then qbThrow:Disconnect(); qbThrow=nil end
            qbLocked=nil; qbHUD.Visible=false
            notif("QB Aimbot","Disabled",Color3.fromRGB(200,60,60))
        end
    end
    qbBg.MouseButton1Click:Connect(function() setQB(not qbEnabled) end)

    secHdr(QBScroll,"SERVER LAG")
    local lagOn=false; local _,lagBg,lagKnob=toggleRow(QBScroll,"Server Lag")
    local function setLag(on)
        lagOn=on; setSw(lagBg,lagKnob,on)
        if on then
            notif("Server Lag","Enabled",A1)
            task.spawn(function()
                while lagOn do
                    pcall(function()
                        local c=LocalPlayer.Character; if not c then return end
                        local hb=c:FindFirstChild("Hitbox"); if not hb then return end
                        local re=hb:FindFirstChild("RemoteEvent"); if not re then return end
                        for _=1,50 do re:FireServer({"BallCamera"}); re:FireServer({"Ball Camera"}); re:FireServer({"GiveBallCam"}) end
                    end)
                    task.wait(0.05)
                end
            end)
        else notif("Server Lag","Disabled",Color3.fromRGB(200,60,60)) end
    end
    lagBg.MouseButton1Click:Connect(function() setLag(not lagOn) end)
end

-- CATCHING PAGE
local CatchPage, CatchScroll = makeScrollPage()
do
    secHdr(CatchScroll,"HITBOX MAGNET")
    makeSlider(CatchScroll,"HITBOX SIZE",1,50,1,1,function(v)
        pcall(function()
            local c=LocalPlayer.Character; if not c then return end
            local hb=c:FindFirstChild("Hitbox"); if not hb then return end
            hb.Size=Vector3.new(v+3,v+5,v+3)
        end)
    end)
    secHdr(CatchScroll,"OP Magnets")
    local opOn=false; local opRange=10; local opLoop=nil; local opShow=false; local opHBs={}; local opHBL=nil; local opKey=Enum.KeyCode.B
    local _,opBg,opKn=toggleRow(CatchScroll,"Enable OP Magnets")
    local _,opVBg,opVKn=toggleRow(CatchScroll,"Show Hitbox Visual")
    makeSlider(CatchScroll,"MAGNET RANGE",1,100,10,1,function(v) opRange=v end)
    local function opRemHB()
        for _,hb in pairs(opHBs) do pcall(function() hb:Destroy() end) end
        opHBs={}; if opHBL then opHBL:Disconnect(); opHBL=nil end
    end
    local function opStartViz()
        opRemHB(); if not opShow then return end
        opHBL=RunService.Heartbeat:Connect(function()
            for _,v in pairs(workspace:GetChildren()) do
                if v.Name=="Football" and v:IsA("BasePart") then
                    if not opHBs[v] then
                        local hb=Instance.new("Part"); hb.Size=Vector3.new(opRange,opRange,opRange); hb.Anchored=true
                        hb.CanCollide=false; hb.Transparency=0.25; hb.Material=Enum.Material.ForceField
                        hb.Color=A1; hb.CastShadow=false; hb.CFrame=v.CFrame; hb.Shape=Enum.PartType.Ball; hb.Parent=v; opHBs[v]=hb
                    else local h=opHBs[v]; if h and h.Parent then h.CFrame=v.CFrame; h.Size=Vector3.new(opRange,opRange,opRange) else opHBs[v]=nil end end
                end
            end
        end)
    end
    opVBg.MouseButton1Click:Connect(function() opShow=not opShow; setSw(opVBg,opVKn,opShow); if opShow then opStartViz() else opRemHB() end end)
    local opML=nil
    local function setOp(on)
        opOn=on; setSw(opBg,opKn,on)
        if on then
            if opML then opML:Disconnect(); opML=nil end
            opML=RunService.RenderStepped:Connect(function()
                if not opOn then return end
                local c=LocalPlayer.Character; if not c then return end
                local hrp=c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
                for _,v in next,workspace:GetChildren() do
                    if v.Name=="Football" then
                        pcall(function() v.CanCollide=false end)
                        if (v.Position-hrp.Position).Magnitude<=opRange then
                            pcall(function() v.CFrame=hrp.CFrame; firetouchinterest(hrp,v,0); firetouchinterest(hrp,v,0) end)
                        end
                    end
                end
            end)
            notif("OP Magnets","Enabled",A1)
        else
            if opML then opML:Disconnect(); opML=nil end
            opRemHB(); notif("OP Magnets","Disabled",Color3.fromRGB(200,60,60))
        end
    end
    opBg.MouseButton1Click:Connect(function() setOp(not opOn) end)
end

-- AUTOMATION PAGE
local AutoPage, AutoScroll = makeScrollPage()
local autoTuckEnabled=false; local autoTuckConn=nil; local autoTuckKey=Enum.KeyCode.C; local autoTuckDelay=0.09
do
    secHdr(AutoScroll,"Auto Tuck")
    local _,atBg,atKn=toggleRow(AutoScroll,"Auto Tuck on Catch")
    makeSlider(AutoScroll,"Tuck Speed (1=slow 15=fast)",1,15,8,1,function(v) autoTuckDelay=0.01+(0.5-0.01)*(1-(v-1)/14) end)
    local function hookTuck(char)
        if autoTuckConn then autoTuckConn:Disconnect(); autoTuckConn=nil end
        autoTuckConn=char.ChildAdded:Connect(function(child)
            if not autoTuckEnabled then return end
            if child.Name~="Football" or not child:IsA("Tool") then return end
            local h=child:WaitForChild("Handle",2); if not h then return end
            local re=h:WaitForChild("RemoteEvent",2); if not re then return end
            if autoTuckDelay>0 then task.wait(autoTuckDelay) end
            if not autoTuckEnabled or not child.Parent then return end
            pcall(function() re:FireServer({"Tuck"}) end)
        end)
    end
    local function setTuck(on)
        autoTuckEnabled=on; setSw(atBg,atKn,on)
        if on then local c=LocalPlayer.Character; if c then hookTuck(c) end; notif("Auto Tuck","Enabled",A1)
        else if autoTuckConn then autoTuckConn:Disconnect(); autoTuckConn=nil end; notif("Auto Tuck","Disabled",Color3.fromRGB(200,60,60)) end
    end
    atBg.MouseButton1Click:Connect(function() setTuck(not autoTuckEnabled) end)

    secHdr(AutoScroll,"Auto Truck")
    local truckOn=false; local truckDist=10
    local _,trBg,trKn=toggleRow(AutoScroll,"Auto Truck")
    makeSlider(AutoScroll,"Truck Rnage",1,30,10,1,function(v) truckDist=v end)
    local function setTruck(on)
        truckOn=on; setSw(trBg,trKn,on)
        notif("Auto Truck",on and "Enabled" or "Disabled",on and A1 or Color3.fromRGB(200,60,60))
    end
    trBg.MouseButton1Click:Connect(function() setTruck(not truckOn) end)
    RunService.RenderStepped:Connect(function()
        if not truckOn or not LocalPlayer.Character then return end
        local char=LocalPlayer.Character
        local fb=char:FindFirstChild("Football"); if not fb then return end
        local h=fb:FindFirstChild("Handle"); if not h then return end
        local re=h:FindFirstChild("RemoteEvent"); if not re then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                local er=p.Character:FindFirstChild("HumanoidRootPart")
                if er and (hrp.Position-er.Position).Magnitude<=truckDist then
                    pcall(function() re:FireServer({"Truck",true}) end)
                end
            end
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function(c) task.wait(1); if autoTuckEnabled then hookTuck(c) end; runRCFA() end)
end

-- PHYSICS PAGE
local PhysicsPage, PhysicsScroll = makeScrollPage()
local truckValue=0; local truckActive=false; local autoUnstunOn=false; local rbStunOn=false
do
    secHdr(PhysicsScroll,"TRUCK POWER")
    local _,getTv=makeSlider(PhysicsScroll,"TRUCK POWER",0,500,0,1,function(v) truckValue=v end)
    applyRow(PhysicsScroll,"Toggle Truck Power",function(btn)
        local c=LocalPlayer.Character
        if not c or not c:FindFirstChild("Hitbox") then btn.Text="FAIL"; btn.BackgroundColor3=Color3.fromRGB(180,50,50)
            task.delay(2,function() btn.Text="APPLY"; tw(btn,{BackgroundColor3=A2}) end); return end
        if truckActive then truckActive=false; btn.Text="APPLY"; tw(btn,{BackgroundColor3=A2})
        else truckActive=true; btn.Text="ON"; btn.BackgroundColor3=Color3.fromRGB(30,140,80)
            fire("Power",getTv())
            LocalPlayer.CharacterAdded:Connect(function() task.wait(1); if truckActive then fire("Power",getTv()) end end)
            task.spawn(function() while truckActive do task.wait(0.5); fire("Power",getTv()) end end)
        end
    end)

    secHdr(PhysicsScroll,"STUN")
    local _,auBg,auKn=toggleRow(PhysicsScroll,"Auto Unstun")
    local function runUnstun()
        while autoUnstunOn and LocalPlayer.Character do
            local c=LocalPlayer.Character
            local hum=c:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
            local hb=c:FindFirstChild("Hitbox")
            if hb then local cv=hb:FindFirstChild("CharacterValues"); if cv then
                local dn=cv:FindFirstChild("Downed"); if dn then pcall(function() dn.Value=false end) end
                local tk=cv:FindFirstChild("Tackle"); if tk then pcall(function() tk.Value=false end) end
            end end
            task.wait(0.1)
        end
    end
    local function setUnstun(on)
        autoUnstunOn=on; setSw(auBg,auKn,on)
        if on then task.spawn(runUnstun); notif("Auto Unstun","Enabled",A1)
        else notif("Auto Unstun","Disabled",Color3.fromRGB(200,60,60)) end
    end
    auBg.MouseButton1Click:Connect(function() setUnstun(not autoUnstunOn) end)

    local _,rbBg,rbKn=toggleRow(PhysicsScroll,"RB Stun Aura")
    local function setRbStun(on)
        rbStunOn=on; setSw(rbBg,rbKn,on)
        local c=LocalPlayer.Character; if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local hb=c:FindFirstChild("Hitbox")
        if on then
            if hb then pcall(function() hb.CanTouch=false end)
                local cv=hb:FindFirstChild("CharacterValues"); if cv then local dn=cv:FindFirstChild("Downed"); if dn then pcall(function() dn.Value=false end) end end
            end
            pcall(function() hum.PlatformStand=true end); notif("RB Stun","Enabled",A1)
        else
            if hb then pcall(function() hb.CanTouch=true end) end
            pcall(function() hum.PlatformStand=false end); notif("RB Stun","Disabled",Color3.fromRGB(200,60,60))
        end
    end
    rbBg.MouseButton1Click:Connect(function() setRbStun(not rbStunOn) end)

    task.spawn(function()
        while true do task.wait()
            if autoUnstunOn or rbStunOn then
                local c=LocalPlayer.Character
                local hb=c and c:FindFirstChild("Hitbox"); local cv=hb and hb:FindFirstChild("CharacterValues")
                if cv then
                    local dn=cv:FindFirstChild("Downed"); local tk=cv:FindFirstChild("Tackle")
                    if dn and dn.Value then pcall(function() dn.Value=false end) end
                    if tk and tk.Value then pcall(function() tk.Value=false end) end
                end
                local hum=c and c:FindFirstChildOfClass("Humanoid")
                if hum and (hum:GetState()==Enum.HumanoidStateType.Physics or hum:GetState()==Enum.HumanoidStateType.FallingDown) then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                end
            end
        end
    end)

    secHdr(PhysicsScroll,"BLOCK / PBU")
    local blockV=0; local _,getBV=makeSlider(PhysicsScroll,"BLOCK POWER",0,1000,0,5,function(v) blockV=v end)
    applyRow(PhysicsScroll,"Apply Block Power",function(btn)
        fire("BlockPower",blockV); btn.BackgroundColor3=Color3.fromRGB(30,140,80)
        task.delay(1,function() tw(btn,{BackgroundColor3=A2}) end)
    end)
    LocalPlayer.CharacterAdded:Connect(function() task.wait(1); fire("BlockPower",blockV) end)
    local pbuV=0; local _,getPV=makeSlider(PhysicsScroll,"PBU POWER",0,99,0,1,function(v) pbuV=v end)
    applyRow(PhysicsScroll,"Apply PBU Power",function(btn)
        fire("PBU",pbuV); btn.BackgroundColor3=Color3.fromRGB(30,140,80)
        task.delay(1,function() tw(btn,{BackgroundColor3=A2}) end)
    end)
    LocalPlayer.CharacterAdded:Connect(function() task.wait(1); fire("PBU",pbuV) end)
    LocalPlayer.CharacterAdded:Connect(function(c) task.wait(1)
        if autoUnstunOn then task.spawn(runUnstun) end
        if rbStunOn then setRbStun(true) end
        if truckActive then fire("Power",getTv()) end
    end)
end

-- LOCAL PAGE
local LocalPage, LocalScroll = makeScrollPage()
do
    secHdr(LocalScroll,"WALK SPEED")
    inputRow(LocalScroll,"e.g. 24",function(n)
        local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed=n end
    end)
    secHdr(LocalScroll,"JUMP POWER")
    inputRow(LocalScroll,"e.g. 75",function(n)
        local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower=n end
    end)
end

-- HSBL PAGE
local HSBLPage, HSBLScroll = makeScrollPage()
local _G_Aim=false; local _G_Pow=false; local hasBall=false; local jumping=false
local aimBind=nil; local powBind=nil; local waitBind=nil
local aimBindBtn,powBindBtn
do
    secHdr(HSBLScroll,"SILENT AIMBOT")
    local _,aBg,aKn=toggleRow(HSBLScroll,"Aimbot Enabled")
    local function setAim(on)
        _G_Aim=on; setSw(aBg,aKn,on)
        notif("HSBL Aimbot",on and "Enabled" or "Disabled",on and A1 or Color3.fromRGB(200,60,60))
    end
    aBg.MouseButton1Click:Connect(function() setAim(not _G_Aim) end)
    -- Aimbot keybind
    local abRow=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,BorderSizePixel=0,Parent=HSBLScroll})
    lbl(abRow,"Aimbot Keybind",13,TW).Position=UDim2.new(0,16,0,0)
    aimBindBtn=mk("TextButton",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-112,0.5,-14),
        BackgroundColor3=BG3,BorderSizePixel=0,Text="Set Key",TextColor3=A1,TextSize=11,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=abRow})
    corner(aimBindBtn,UDim.new(0,7)); bstroke(aimBindBtn,BDR,1); hdiv(abRow).Position=UDim2.new(0,0,1,-1)
    aimBindBtn.MouseButton1Click:Connect(function() waitBind="Aim"; aimBindBtn.Text="Press..."; notif("HSBL","Press a key to bind Aimbot",A1) end)

    secHdr(HSBLScroll,"AUTO POWER")
    local _,pBg,pKn=toggleRow(HSBLScroll,"Auto Power Enabled")
    local function setPow(on)
        _G_Pow=on; setSw(pBg,pKn,on)
        notif("HSBL Auto Power",on and "Enabled" or "Disabled",on and A1 or Color3.fromRGB(200,60,60))
    end
    pBg.MouseButton1Click:Connect(function() setPow(not _G_Pow) end)
    local pbRow=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,BorderSizePixel=0,Parent=HSBLScroll})
    lbl(pbRow,"Auto Power Keybind",13,TW).Position=UDim2.new(0,16,0,0)
    powBindBtn=mk("TextButton",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-112,0.5,-14),
        BackgroundColor3=BG3,BorderSizePixel=0,Text="Set Key",TextColor3=A1,TextSize=11,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=pbRow})
    corner(powBindBtn,UDim.new(0,7)); bstroke(powBindBtn,BDR,1); hdiv(pbRow).Position=UDim2.new(0,0,1,-1)
    powBindBtn.MouseButton1Click:Connect(function() waitBind="Pow"; powBindBtn.Text="Press..."; notif("HSBL","Press a key to bind Auto Power",A1) end)

    -- HSBL LOGIC
    local satk=nil; local plr=LocalPlayer
    local function loadAnim(char)
        satk=nil; local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local anim=hum:FindFirstChildOfClass("Animator") or Instance.new("Animator",hum)
        local bb=char:FindFirstChild("Basketball"); if not bb then return end
        local af=bb:FindFirstChild("Animations"); if not af then return end
        local sa=af:FindFirstChild("Shoot"); if sa then satk=anim:LoadAnimation(sa) end
    end
    local function getGoal()
        local c=plr.Character; local t=c and c:FindFirstChild("Torso"); if not t then return math.huge,nil end
        local cl,gl=math.huge,nil
        for _,v in ipairs(workspace:GetDescendants()) do
            if v.Name=="Goal" then local d=(t.Position-v.Position).Magnitude; if d<cl then cl=d; gl=v end end
        end
        return cl,gl
    end
    local function getpow() local c=plr.Character; if not c then return 0 end; local pv=c:FindFirstChild("PowerValue"); return pv and pv.Value or 0 end
    local adjP=false
    local function adjPow(tgt)
        if adjP then return end; adjP=true
        task.spawn(function()
            local c=plr.Character; if not c then adjP=false; return end
            local ev=c:FindFirstChild("Events"); if not ev then adjP=false; return end
            local up=ev:FindFirstChild("PowerUp"); local dn=ev:FindFirstChild("PowerDown")
            while getpow()~=tgt do
                if getpow()<tgt then pcall(function() if up then up:FireServer() end end)
                else pcall(function() if dn then dn:FireServer() end end) end
                task.wait(0.1)
            end
            adjP=false
        end)
    end
    local function arcFor()
        local d=math.floor(select(1,getGoal()))
        local t={[12]=15,[13]=15,[14]=20,[15]=20,[16]=15,[17]=15,[18]=25,[19]=20,[20]=20,[21]=20,[22]=25,[23]=25,[24]=20,[25]=20,[26]=15,[27]=25,[28]=25,[29]=20,[30]=20,[31]=13,[32]=8,[33]=8,[34]=6,[35]=6,[36]=6,[37]=12,[38]=12,[39]=24,[40]=24,[41]=24,[42]=13,[43]=13,[44]=15,[45]=22,[46]=22,[47]=16,[48]=16,[49]=19,[50]=21,[51]=17,[52]=20,[53]=22,[54]=22,[55]=28,[56]=29,[57]=25,[58]=25,[59]=38,[60]=38,[61]=38,[62]=25,[63]=25,[64]=27,[65]=31,[66]=75,[67]=75,[68]=70,[69]=70,[70]=35,[71]=35,[72]=38,[73]=45,[74]=50,[75]=55,[76]=60}
        if jumping and d<=12 then return d<=10 and 20 or 15 end
        return t[d] or 60
    end
    local function doShoot()
        local gl=select(2,getGoal()); local arc=arcFor()
        if gl and arc and _G_Aim then
            local bb=plr.Character and plr.Character:FindFirstChild("Basketball")
            if bb then local se=bb:FindFirstChild("ShootEvent"); if se then pcall(function() se:FireServer(plr.Character.Humanoid,gl.Position+Vector3.new(0,arc,0)) end) end end
        end
    end
    local function onJump()
        if _G_Aim and hasBall then
            jumping=true; if satk then pcall(function() satk:Play() end) end
            task.wait(0.325); doShoot(); task.wait(0.1); jumping=false
        end
    end
    RunService.Stepped:Connect(function()
        if not _G_Pow or not hasBall or not plr.Character then return end
        local d=math.floor(select(1,getGoal()))
        if jumping and d<=12 then adjPow(25) elseif d>=13 and d<=16 then adjPow(30)
        elseif d<=21 then adjPow(35) elseif d<=26 then adjPow(40) elseif d<=31 then adjPow(45)
        elseif d<=33 then adjPow(50) elseif d<=41 then adjPow(55) elseif d<=46 then adjPow(60)
        elseif d<=50 then adjPow(65) elseif d<=56 then adjPow(70) elseif d<=61 then adjPow(75)
        elseif d<=65 then adjPow(80) elseif d<=74 then adjPow(85) elseif d<=76 then adjPow(90) end
    end)
    local function hookHSBL(char)
        task.wait(0.4); loadAnim(char)
        pcall(function() char:WaitForChild("Humanoid").Jumping:Connect(onJump) end)
        char.ChildAdded:Connect(function(v) if v.Name=="Basketball" then hasBall=true; loadAnim(char) end end)
        char.ChildRemoved:Connect(function(v) if v.Name=="Basketball" then hasBall=false end end)
    end
    if plr.Character then hookHSBL(plr.Character) end
    plr.CharacterAdded:Connect(hookHSBL)
end

-- MISC PAGE
local MiscPage, MiscScroll = makeScrollPage()
do
    secHdr(MiscScroll,"ANTI-CHEAT")
    local acRow=mk("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,BorderSizePixel=0,Parent=MiscScroll})
    lbl(acRow,"Auto-disabled on load & respawn",11,TM).Position=UDim2.new(0,16,0,0)
    hdiv(acRow).Position=UDim2.new(0,0,1,-1)
    applyRow(MiscScroll,"Disable Anti-Cheat Now",function(btn)
        runRCFA(); btn.Text="DONE"; btn.BackgroundColor3=Color3.fromRGB(30,140,80)
        notif("RCFA","Disabled",A1); task.delay(2,function() btn.Text="APPLY"; tw(btn,{BackgroundColor3=A2}) end)
    end)

    secHdr(MiscScroll,"PERFORMANCE")
    local fRow=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,BorderSizePixel=0,Parent=MiscScroll})
    lbl(fRow,"FPS Booster",13,TW).Position=UDim2.new(0,16,0,0)
    local fBtn=mk("TextButton",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-112,0.5,-14),BackgroundColor3=A2,BorderSizePixel=0,Text="ACTIVATE",TextColor3=TW,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=fRow})
    corner(fBtn,UDim.new(0,7)); hdiv(fRow).Position=UDim2.new(0,0,1,-1)
    fBtn.MouseEnter:Connect(function() tw(fBtn,{BackgroundColor3=A1}) end)
    fBtn.MouseLeave:Connect(function() tw(fBtn,{BackgroundColor3=A2}) end)
    fBtn.MouseButton1Click:Connect(function()
        fBtn.Text="RUNNING"; fBtn.BackgroundColor3=Color3.fromRGB(30,140,80)
        pcall(function()
            _G.Ignore={}; _G.Settings={Players={["Ignore Me"]=true,["Ignore Others"]=true,["Ignore Tools"]=true},Images={Invisible=true,Destroy=false},Particles={Invisible=true,Destroy=false},Other={["FPS Cap"]=1000,["No Camera Effects"]=true,["No Clothes"]=true,["Low Water Graphics"]=true,["No Shadows"]=true,["Low Rendering"]=true,["Low Quality Parts"]=true,["Low Quality Models"]=true,["Reset Materials"]=true}}
            loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
        end)
        notif("FPS Booster","Applied",A1)
    end)

    secHdr(MiscScroll,"TOOLS")
    local iRow=mk("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1,BorderSizePixel=0,Parent=MiscScroll})
    lbl(iRow,"Infinite Yield",13,TW).Position=UDim2.new(0,16,0,0)
    local iBtn=mk("TextButton",{Size=UDim2.new(0,96,0,28),Position=UDim2.new(1,-112,0.5,-14),BackgroundColor3=A2,BorderSizePixel=0,Text="LOAD",TextColor3=TW,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=iRow})
    corner(iBtn,UDim.new(0,7)); hdiv(iRow).Position=UDim2.new(0,0,1,-1)
    iBtn.MouseEnter:Connect(function() tw(iBtn,{BackgroundColor3=A1}) end)
    iBtn.MouseLeave:Connect(function() tw(iBtn,{BackgroundColor3=A2}) end)
    iBtn.MouseButton1Click:Connect(function()
        iBtn.Text="..."; iBtn.BackgroundColor3=BDR
        task.spawn(function()
            local ok=pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
            if ok then iBtn.Text="LOADED"; iBtn.BackgroundColor3=Color3.fromRGB(30,140,80); notif("Infinite Yield","Loaded",A1)
            else iBtn.Text="FAIL"; iBtn.BackgroundColor3=Color3.fromRGB(180,50,50); notif("Infinite Yield","Failed",Color3.fromRGB(200,60,60)) end
        end)
    end)

    secHdr(MiscScroll,"ANTI AFK")
    local _,afkBg,afkKn=toggleRow(MiscScroll,"Anti AFK")
    local afkOn=false; local afkConn=nil
    local function setAfk(on)
        afkOn=on; setSw(afkBg,afkKn,on)
        if on then
            afkConn=RunService.Heartbeat:Connect(function()
                local vu=LocalPlayer:FindFirstChild("VirtualUser")
                if vu then pcall(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end
            end)
            LocalPlayer.Idled:Connect(function() if afkOn then pcall(function() LocalPlayer:Move(Vector3.new(0,0,0)) end) end end)
            notif("Anti AFK","Enabled",A1)
        else if afkConn then afkConn:Disconnect(); afkConn=nil end; notif("Anti AFK","Disabled",Color3.fromRGB(200,60,60)) end
    end
    afkBg.MouseButton1Click:Connect(function() setAfk(not afkOn) end)

    secHdr(MiscScroll,"KEYBINDS")
    local RSRV={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.E]=true,[Enum.KeyCode.Q]=true,[Enum.KeyCode.F]=true,[Enum.KeyCode.R]=true,[Enum.KeyCode.G]=true,[Enum.KeyCode.H]=true,[Enum.KeyCode.N]=true,[Enum.KeyCode.M]=true,[Enum.KeyCode.X]=true,[Enum.KeyCode.Z]=true,[Enum.KeyCode.Space]=true,[Enum.KeyCode.LeftShift]=true,[Enum.KeyCode.RightShift]=true,[Enum.KeyCode.Escape]=true,[Enum.KeyCode.Backspace]=true}
    local function kbRow(scroll, label, startKey, useRes, onBound)
        local ck=startKey
        local row=mk("Frame",{Size=UDim2.new(1,0,0,52),BackgroundTransparency=1,BorderSizePixel=0,Parent=scroll})
        lbl(row,label,13,TW).Position=UDim2.new(0,16,0,0)
        local kbtn=mk("TextButton",{Size=UDim2.new(0,88,0,26),Position=UDim2.new(1,-104,0.5,-13),BackgroundColor3=BG3,BorderSizePixel=0,Text=startKey.Name,TextColor3=A1,TextSize=11,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=row})
        corner(kbtn,UDim.new(0,6)); bstroke(kbtn,BDR,1); hdiv(row).Position=UDim2.new(0,0,1,-1)
        local lst=false
        kbtn.MouseButton1Click:Connect(function()
            if lst then return end; lst=true; kbtn.Text="..."; kbtn.TextColor3=TM
            local c; c=UserInputService.InputBegan:Connect(function(i,_)
                if i.UserInputType~=Enum.UserInputType.Keyboard then return end
                if i.KeyCode==Enum.KeyCode.Escape then kbtn.Text=ck.Name; kbtn.TextColor3=A1; lst=false; c:Disconnect(); return end
                if useRes and RSRV[i.KeyCode] then return end
                ck=i.KeyCode; kbtn.Text=i.KeyCode.Name; kbtn.TextColor3=A1; lst=false; c:Disconnect()
                if onBound then onBound(i.KeyCode) end
            end)
        end)
    end
    kbRow(MiscScroll,"UI Toggle",toggleKey,false,function(k) toggleKey=k end)
    kbRow(MiscScroll,"Auto Tuck",autoTuckKey,true,function(k) autoTuckKey=k end)

    secHdr(MiscScroll,"ABOUT")
    local ab=mk("Frame",{Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,BorderSizePixel=0,Parent=MiscScroll})
    local al=lbl(ab,"Veltra v"..VERSION.."  |  Rofootball  |  by Syphen",11,TM); al.Size=UDim2.new(1,-32,1,0); al.Position=UDim2.new(0,16,0,0)
end

-- ///////////////////////////////////////////////
-- // GLOBAL INPUT
-- ///////////////////////////////////////////////
UserInputService.InputEnded:Connect(function(i)
    if isClick(i.UserInputType) then for _,d in ipairs(allDrags) do d.isDragging=false end end
end)
UserInputService.InputChanged:Connect(function(i)
    if not isMove(i.UserInputType) then return end
    for _,d in ipairs(allDrags) do if d.isDragging then d.onInput(i.Position.X) end end
end)

UserInputService.InputBegan:Connect(function(i, proc)
    if waitBind then
        local bind=i.KeyCode~=Enum.KeyCode.Unknown and i.KeyCode or nil
        if not bind then return end
        if waitBind=="Aim" then aimBind=bind; aimBindBtn.Text=bind.Name; notif("HSBL","Aimbot -> "..bind.Name,A1)
        elseif waitBind=="Pow" then powBind=bind; powBindBtn.Text=bind.Name; notif("HSBL","Auto Power -> "..bind.Name,A1) end
        waitBind=nil; return
    end
    if proc then return end
    if i.UserInputType~=Enum.UserInputType.Keyboard then return end
    if aimBind and i.KeyCode==aimBind then
        local cur=not _G_Aim; _G_Aim=cur
        -- toggle via the HSBL page toggle (reuse logic)
        notif("HSBL Aimbot",cur and "Enabled" or "Disabled",cur and A1 or Color3.fromRGB(200,60,60))
    end
    if powBind and i.KeyCode==powBind then
        local cur=not _G_Pow; _G_Pow=cur
        notif("HSBL Auto Power",cur and "Enabled" or "Disabled",cur and A1 or Color3.fromRGB(200,60,60))
    end
end)


-- Pages lookup so RCFA dropdown knows what to open
local rcfaSubPages = {
    {label="QB",        icon="QB", page=QBPage},
    {label="Catching",  icon="CT", page=CatchPage},
    {label="Automation",icon="AU", page=AutoPage},
    {label="Physics",   icon="PH", page=PhysicsPage},
    {label="Local",     icon="LC", page=LocalPage},
}

-- Sidebar scroll container (so dropdown pushes content down cleanly)
local sbScroll=mk("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,
    ScrollBarThickness=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ScrollingEnabled=true,ScrollingDirection=Enum.ScrollingDirection.Y,Parent=Sidebar})
local sbLayout=mk("UIListLayout",{Padding=UDim.new(0,2),Parent=sbScroll})

local function navBtn(parent, labelTxt, icon)
    local btn=mk("TextButton",{Size=UDim2.new(1,-12,0,38),BackgroundColor3=BG2,BackgroundTransparency=1,
        BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=parent})
    corner(btn,UDim.new(0,8))
    local bar=mk("Frame",{Size=UDim2.new(0,3,0.6,0),Position=UDim2.new(0,0,0.2,0),BackgroundColor3=A1,BorderSizePixel=0,Visible=false,Parent=btn})
    corner(bar,UDim.new(0,2))
    local ico=lbl(btn,icon,10,TM,true); ico.Size=UDim2.new(0,22,1,0); ico.Position=UDim2.new(0,8,0,0); ico.TextXAlignment=Enum.TextXAlignment.Center
    local nam=lbl(btn,labelTxt,11,TM); nam.Size=UDim2.new(1,-34,1,0); nam.Position=UDim2.new(0,32,0,0)
    -- pad frame for layout
    local pad=mk("Frame",{Size=UDim2.new(1,0,0,42),BackgroundTransparency=1,BorderSizePixel=0,Parent=sbScroll})
    btn.Parent=pad
    btn.Size=UDim2.new(1,-8,0,36); btn.Position=UDim2.new(0,4,0,3)
    return btn, bar, ico, nam, pad
end

local function subNavBtn(parent, labelTxt, icon)
    local btn=mk("TextButton",{Size=UDim2.new(1,-20,0,30),BackgroundColor3=BG3,BackgroundTransparency=1,
        BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=parent})
    corner(btn,UDim.new(0,6))
    local dot=mk("Frame",{Size=UDim2.new(0,4,0,4),Position=UDim2.new(0,10,0.5,-2),BackgroundColor3=TM,BorderSizePixel=0,Parent=btn})
    corner(dot,UDim.new(1,0))
    local icoL=lbl(btn,icon,9,TM,true); icoL.Size=UDim2.new(0,18,1,0); icoL.Position=UDim2.new(0,18,0,0); icoL.TextXAlignment=Enum.TextXAlignment.Center
    local nam=lbl(btn,labelTxt,10,TM); nam.Size=UDim2.new(1,-40,1,0); nam.Position=UDim2.new(0,38,0,0)
    return btn, dot, icoL, nam
end

-- Top spacer
mk("Frame",{Size=UDim2.new(1,0,0,8),BackgroundTransparency=1,BorderSizePixel=0,Parent=sbScroll})

-- HOME button
local homeBtn,homeBar,homeIco,homeNam,homePad = navBtn(sbScroll,"Home","H")

-- RCFA button + dropdown
local rcfaBtn,rcfaBar,rcfaIco,rcfaNam,rcfaPad = navBtn(sbScroll,"RCFA","RF")
-- Arrow indicator
local rcfaArrow=mk("TextLabel",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(1,-18,0.5,-7),
    BackgroundTransparency=1,Text="v",TextColor3=TM,TextSize=10,Font=Enum.Font.GothamBold,Parent=rcfaBtn})
-- Dropdown container (inside sbScroll, right after rcfaPad)
local rcfaDrop=mk("Frame",{Size=UDim2.new(1,0,0,0),BackgroundColor3=Color3.fromRGB(8,14,28),BorderSizePixel=0,ClipsDescendants=true,Parent=sbScroll})
corner(rcfaDrop,UDim.new(0,6))
local rcfaOpen=false
-- Sub-buttons
local rcfaSubBtns={}
for _,def in ipairs(rcfaSubPages) do
    local sb,sdot,sico,snam=subNavBtn(rcfaDrop,def.label,def.icon)
    sb.Parent=rcfaDrop
    table.insert(rcfaSubBtns,{btn=sb,dot=sdot,ico=sico,nam=snam,page=def.page})
end
-- Layout for dropdown
local rcfaDropLayout=mk("UIListLayout",{Padding=UDim.new(0,2),Parent=rcfaDrop})
mk("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,4),Parent=rcfaDrop})
local RCFA_FULL_H = #rcfaSubPages * 32 + 12

-- HSBL button
local hsblBtn,hsblBar,hsblIco,hsblNam,hsblPad = navBtn(sbScroll,"HSBL","HS")

-- MISC button
local miscBtn,miscBar,miscIco,miscNam,miscPad = navBtn(sbScroll,"Misc","MC")

-- Bottom spacer
mk("Frame",{Size=UDim2.new(1,0,0,8),BackgroundTransparency=1,BorderSizePixel=0,Parent=sbScroll})

-- NAV STATE
local allNavBtns = {
    {btn=homeBtn,bar=homeBar,ico=homeIco,nam=homeNam},
    {btn=rcfaBtn,bar=rcfaBar,ico=rcfaIco,nam=rcfaNam},
    {btn=hsblBtn,bar=hsblBar,ico=hsblIco,nam=hsblNam},
    {btn=miscBtn,bar=miscBar,ico=miscIco,nam=miscNam},
}

local function deactivateNav()
    for _,nb in pairs(allNavBtns) do
        tw(nb.btn,{BackgroundColor3=BG2,BackgroundTransparency=1})
        nb.bar.Visible=false; nb.ico.TextColor3=TM; nb.nam.TextColor3=TM; nb.nam.Font=Enum.Font.Gotham
    end
    for _,sb in ipairs(rcfaSubBtns) do
        sb.dot.BackgroundColor3=TM; sb.ico.TextColor3=TM; sb.nam.TextColor3=TM; sb.nam.Font=Enum.Font.Gotham
        tw(sb.btn,{BackgroundColor3=BG3,BackgroundTransparency=1})
    end
    for _,p in ipairs(allPages) do p.Visible=false end
end

local function activateNav(nb)
    deactivateNav()
    tw(nb.btn,{BackgroundColor3=BG2,BackgroundTransparency=0})
    nb.bar.Visible=true; nb.ico.TextColor3=A1; nb.nam.TextColor3=TW; nb.nam.Font=Enum.Font.GothamBold
end

local function setRCFADropOpen(open)
    rcfaOpen=open
    TweenService:Create(rcfaDrop,TweenInfo.new(0.2,Enum.EasingStyle.Quint,open and Enum.EasingDirection.Out or Enum.EasingDirection.In),{Size=UDim2.new(1,0,0,open and RCFA_FULL_H or 0)}):Play()
    tw(rcfaArrow,{TextColor3=open and A1 or TM})
    rcfaArrow.Text = open and "^" or "v"
end

local function openRCFASub(sb)
    for _,s in ipairs(rcfaSubBtns) do
        s.dot.BackgroundColor3=TM; s.ico.TextColor3=TM; s.nam.TextColor3=TM; s.nam.Font=Enum.Font.Gotham
        tw(s.btn,{BackgroundColor3=BG3,BackgroundTransparency=1})
    end
    sb.dot.BackgroundColor3=A1; sb.ico.TextColor3=A1; sb.nam.TextColor3=TW; sb.nam.Font=Enum.Font.GothamBold
    tw(sb.btn,{BackgroundColor3=BG3,BackgroundTransparency=0})
    showPage(sb.page)
end

-- Connect nav buttons
homeBtn.MouseButton1Click:Connect(function()
    activateNav(allNavBtns[1]); setRCFADropOpen(false); showPage(HomePage)
end)
homeBtn.MouseEnter:Connect(function() if homeBtn.BackgroundTransparency~=0 then tw(homeBtn,{BackgroundTransparency=0.5,BackgroundColor3=BG2}) end end)
homeBtn.MouseLeave:Connect(function() if homeBtn.BackgroundTransparency~=0 then tw(homeBtn,{BackgroundTransparency=1}) end end)

rcfaBtn.MouseButton1Click:Connect(function()
    activateNav(allNavBtns[2])
    if rcfaOpen then
        setRCFADropOpen(false)
    else
        setRCFADropOpen(true)
        -- activate first sub by default
        openRCFASub(rcfaSubBtns[1])
    end
end)
rcfaBtn.MouseEnter:Connect(function() if rcfaBtn.BackgroundTransparency~=0 then tw(rcfaBtn,{BackgroundTransparency=0.5,BackgroundColor3=BG2}) end end)
rcfaBtn.MouseLeave:Connect(function() if rcfaBtn.BackgroundTransparency~=0 then tw(rcfaBtn,{BackgroundTransparency=1}) end end)

for _,sb in ipairs(rcfaSubBtns) do
    local s=sb
    s.btn.MouseButton1Click:Connect(function()
        activateNav(allNavBtns[2]); openRCFASub(s)
    end)
    s.btn.MouseEnter:Connect(function() if s.btn.BackgroundTransparency~=0 then tw(s.btn,{BackgroundTransparency=0.5,BackgroundColor3=BG3}) end end)
    s.btn.MouseLeave:Connect(function() if s.btn.BackgroundTransparency~=0 then tw(s.btn,{BackgroundTransparency=1}) end end)
end

hsblBtn.MouseButton1Click:Connect(function()
    activateNav(allNavBtns[3]); setRCFADropOpen(false); showPage(HSBLPage)
end)
hsblBtn.MouseEnter:Connect(function() if hsblBtn.BackgroundTransparency~=0 then tw(hsblBtn,{BackgroundTransparency=0.5,BackgroundColor3=BG2}) end end)
hsblBtn.MouseLeave:Connect(function() if hsblBtn.BackgroundTransparency~=0 then tw(hsblBtn,{BackgroundTransparency=1}) end end)

miscBtn.MouseButton1Click:Connect(function()
    activateNav(allNavBtns[4]); setRCFADropOpen(false); showPage(MiscPage)
end)
miscBtn.MouseEnter:Connect(function() if miscBtn.BackgroundTransparency~=0 then tw(miscBtn,{BackgroundTransparency=0.5,BackgroundColor3=BG2}) end end)
miscBtn.MouseLeave:Connect(function() if miscBtn.BackgroundTransparency~=0 then tw(miscBtn,{BackgroundTransparency=1}) end end)

-- Default: Home
activateNav(allNavBtns[1]); showPage(HomePage)

-- ///////////////////////////////////////////////
-- // TITLE BAR CONTROLS
-- ///////////////////////////////////////////////
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

local mob=mk("TextButton",{Size=UDim2.new(0,42,0,42),Position=UDim2.new(0,8,0.5,-21),BackgroundColor3=A2,BorderSizePixel=0,Text="V",TextColor3=TW,TextSize=16,Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=20,Visible=isMobile,Parent=ScreenGui})
corner(mob,UDim.new(1,0)); bstroke(mob,A1,1)
mob.MouseButton1Click:Connect(function() setVis(not guiOpen) end)
mob.TouchTap:Connect(function() setVis(not guiOpen) end)

Window.BackgroundTransparency=1; Window.Position=UDim2.new(0.5,-GUI_W/2,0.5,-GUI_H/2+16)
TweenService:Create(Window,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=0,Position=nPos}):Play()

notif("Voltz v0.1","Loaded  |  Press K to toggle",A1)
print("03092010"..VERSION.." | "..LocalPlayer.Name)


    -- Expose helpers for features script to use
    return {
        showNotif  = notif,
        ScreenGui  = ScreenGui,
        setVis     = setVis,
        allPages   = allPages,
        showPage   = showPage,
        makeScrollPage  = makeScrollPage,
        secHdr          = secHdr,
        toggleRow       = toggleRow,
        makeSlider      = makeSlider,
        applyRow        = applyRow,
        inputRow        = inputRow,
        makeKbRow       = makeKbRow,
    }
end

return VeltraUI
