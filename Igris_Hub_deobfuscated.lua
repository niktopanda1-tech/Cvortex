-- IGRIS Hub: recovered Lua/Luau source.
-- Source: https://github.com/iscoooooooolol/it-hears-you/blob/main/Igris%20Hub.lua
-- Original file SHA-256: b17b523edce01bed056184916b280f071787684b8908d9968379558fc8a24f50
-- Recovered from the supplied obfuscated file; original comments and local names are unavailable.
-- String pools, numeric camouflage and the shared VM dispatcher have been removed.
-- Callback names were assigned during recovery; fn_<number> names identify remaining helpers.
-- Control-flow graphs have been reconstructed as ordinary while/if blocks.
-- Temporary flow values remain at branch boundaries; there is no VM dispatcher.
-- Captured variables use native Lua tables with a .value field.
-- The original external Rayfield load remains; its remote code is not bundled or audited here.
-- Validation: Lua 5.1 syntax; matching initialization plus 33 callback cases in a mock.
-- Network requests and scheduled background tasks were mocked. Not tested inside Roblox.

local env = getfenv and getfenv() or _ENV
local unpackValues = unpack or table.unpack
local selectValues = select
local functions = {}

-- Pathfinding Monster
-- UGC_MonsterCham
-- https://sirius.menu/rayfield
-- LoadingSubtitle
functions.main = function(captures)
    return function(...)
        local args = { ... }
        local A, Ae, B, Be, C, Ce, D, De, E, Ee, Fe, Ge, H, He, I, Ie, J, Je, Ke, Le, M, Me, Ne, Oe, PI, Pe, Q, Qe, Re, Se, Te, U, Ue, V, Ve, We, Xe, Y, Ye, Z, Ze, a, ae, b, be, ce, de, eI, fe, flow, g, ge, he, i, ie, jI, je, ke, l, le, me, ne, oe, p, pe, qe, re, results, se, tI, te, u, ue, v, ve, w, we, x, xe, y, ye, ze
        flow = 5004309
        y, g = {
        }, {
        }
        a = env.Color3
        C = a.fromRGB
        a = C(255, 30, 30)
        i = env.Color3
        J = i.fromRGB
        i = J(255, 120, 120)
        H = env.Color3
        u = H.fromRGB
        H = u(0, 200, 100)
        E = env.Color3
        I = E.fromRGB
        E = I(120, 255, 170)
        he = env.Color3
        Pe = he.fromRGB
        he = Pe(80, 180, 255)
        ze = env.Color3
        re = ze.fromRGB
        ze = re(170, 220, 255)
        M = {
            ['debug'] = true,
            ['monsterEnabled'] = false,
            ['monsterFillColor'] = a,
            ['monsterOutlineColor'] = i,
            ['monsterFillTransparency'] = 0.55,
            ['monsterOutlineTransparency'] = 0,
            ['playerEnabled'] = false,
            ['playerFillColor'] = H,
            ['playerOutlineColor'] = E,
            ['playerFillTransparency'] = 0.55,
            ['playerOutlineTransparency'] = 0,
            ['localEnabled'] = false,
            ['localFillColor'] = he,
            ['localOutlineColor'] = ze,
            ['localFillTransparency'] = 0.55,
            ['localOutlineTransparency'] = 0,
            ['refreshInterval'] = 0.5,
            ['teleportHeightOffset'] = 1,
            ['teleportSettle'] = 0.05,
            ['postFireSettle'] = 0.1,
            ['respawnWait'] = 1,
            ['maxRescanRounds'] = 30,
            ['maxRuntimeSec'] = 300,
            ['returnToStart'] = true,
            ['returnSettle'] = 0.2,
            ['infStamina'] = false,
            ['infHunger'] = false,
            ['infThirst'] = false,
            ['flyEnabled'] = false,
            ['noclipEnabled'] = false,
            ['flySpeed'] = 80,
        }
        Z = {
        }
        Z.value = M
        M = env.game
        B = M.GetService
        B = B(M, 'Players')
        M = {
        }
        M.value = B
        B = env.game
        v = B.GetService
        v = v(B, 'RunService')
        B = {
        }
        B.value = v
        v = env.game
        w = v.GetService
        w = w(v, 'CoreGui')
        v = {
        }
        v.value = w
        w = env.game
        U = w.GetService
        U = U(w, 'Workspace')
        w = {
        }
        w.value = U
        U = env.game
        C = U.GetService
        C = C(U, 'ReplicatedStorage')
        U = env.game
        a = U.GetService
        a = a(U, 'UserInputService')
        J = M.value
        U = J.LocalPlayer
        J = {
        }
        D = functions.debugLog({
            Z,
            y,
            g,
        })
        i = functions.notify({
            Z,
            y,
            g,
        })
        J.value = U
        U = {
        }
        V = {
        }
        U.value = i
        x = functions.fn_4782885({
            y,
            g,
            V,
            v,
        })
        i = {
        }
        i.value = D
        V.value = nil
        D = env.pcall
        b = D(x)
        A = not b
        flow = A and 16116889 or 7441225
        D = A
        if flow and flow >= 7434061 and flow < 7454491 then
            H = V.value
            u = not H
            A = u
            flow = u and 5640993 or 4575008
            if flow and flow >= 4571491 and flow < 4581222 then
                flow = 5640993
                I = V.value
                H = I.Parent
                u = not H
                A = u
            else
            end
            D = A
            flow = 16116889
        else
        end
        flow = D and 7258459 or 13072717
        if flow and flow >= 7219164 and flow < 7261474 then
            x = env.Instance
            flow = 13072717
            D = x.new
            x = D('Folder')
            V.value = x
            D = V.value
            D.Name = 'UGC_Chams_Root'
            D = V.value
            Q = w.value
            D.Parent = Q
            D = U.value
            A = D('CoreGui not writable — falling back to Workspace for HighlightRoot')
        else
        end
        A = {
        }
        D = {
        }
        Q = functions.fn_3455247({
            y,
            g,
            A,
            V,
            U,
        })
        I = functions.fn_3155984({
            A,
            y,
            g,
        })
        A.value = D
        H = functions.fn_8596738({
            A,
            y,
            g,
        })
        u = functions.fn_118555({
            A,
        })
        D = {
        }
        D.value = Q
        Q = {
        }
        Q.value = u
        u = {
        }
        u.value = H
        H = {
        }
        H.value = I
        E = {
        }
        E.value = 'Pathfinding Monster'
        p = {
        }
        p.value = 'UGC_MonsterCham'
        je = functions.fn_2256532({
            w,
            y,
            g,
            E,
        })
        I = {
        }
        Y = functions.fn_9432504({
            Z,
            y,
            g,
            I,
            D,
            p,
            A,
            Q,
        })
        I.value = je
        je = {
        }
        je.value = Y
        l = {
        }
        l.value = 'UGC_PlayerCham'
        Se = {
        }
        te = functions.fn_12611079({
            Z,
            y,
            g,
            M,
            J,
            D,
            Se,
            l,
            A,
            Q,
        })
        Se.value = 'UGC_LocalCham'
        Y = {
        }
        Y.value = te
        Pe = w.value
        te = Pe.ChildAdded
        he = functions.fn_14754215({
            y,
            g,
            E,
            U,
            je,
        })
        Pe = te.Connect
        Pe = Pe(te, he)
        Pe = w.value
        te = Pe.ChildRemoved
        Pe = te.Connect
        he = functions.fn_14826472({
            y,
            g,
            E,
            U,
            Q,
        })
        Pe = Pe(te, he)
        Pe = functions.fn_8749031({
            y,
            g,
            Y,
        })
        te = {
        }
        te.value = Pe
        he = M.value
        flow = 14628278
        Pe = he.PlayerAdded
        re = functions.fn_10826964({
            U,
            y,
            g,
            te,
        })
        he = Pe.Connect
        he = he(Pe, re)
        he = M.value
        Pe = he.PlayerRemoving
        re = functions.fn_2996993({
            y,
            g,
            Q,
        })
        he = Pe.Connect
        he = he(Pe, re)
        Pe = env.ipairs
        fe = M.value
        Fe = fe.GetPlayers
        Oe = {
            Fe(fe),
        }
        fe = {
            Pe(unpackValues(Oe)),
        }
        re = fe[2]
        he = fe[1]
        ze = fe[3]
        while true do
            ze, fe = he(re, ze)
            flow = ze and 10561716 or 15517191
            if flow and flow >= 10561392 and flow < 10735772 then
                Oe = te.value
                flow = 14628278
                Fe = Oe(fe)
            else
            end
            if flow == nil or flow < 14599506 or flow >= 14629805 then
                break
            end
        end
        he = env.task
        Pe = he.spawn
        re = functions.fn_10497903({
            y,
            g,
            Z,
            A,
            je,
            Y,
        })
        he = Pe(re)
        Pe = C.WaitForChild
        Pe = Pe(C, 'Remotes')
        de = functions.fn_211743({
            w,
            y,
            g,
        })
        he = Pe.WaitForChild
        he = he(Pe, 'Crafting')
        re = Pe.WaitForChild
        re = re(Pe, 'Inventory')
        we = {
        }
        ze = he.WaitForChild
        Ce = functions.fn_1463441({
            we,
            B,
            y,
            g,
            J,
            U,
        })
        ze = ze(he, 'CraftItem')
        fe = {
        }
        fe.value = ze
        ze = he.WaitForChild
        ze = ze(he, 'GetRecipes')
        Be = functions.fn_14663644({
            Z,
            y,
            g,
            J,
        })
        Oe = {
        }
        Oe.value = ze
        ze = re.WaitForChild
        ge = {
        }
        Xe = {
        }
        ze = ze(re, 'GatherMaterial')
        We = functions.fn_4648727({
            y,
            g,
        })
        Me = functions.fn_2560884({
            Oe,
            i,
            y,
            g,
            Xe,
            ge,
            U,
        })
        Fe = {
        }
        Fe.value = ze
        Xe.value = nil
        ze = {
        }
        Te = functions.fn_8610515({
            J,
            y,
            g,
        })
        ge.value = ze
        ye = functions.fn_6940948({
            J,
            y,
            g,
        })
        ze = {
        }
        ze.value = Me
        Ze = {
        }
        Me = {
        }
        Me.value = ye
        ye = {
        }
        me = functions.fn_3427359({
            ye,
            y,
            g,
        })
        ye.value = Te
        Te = {
        }
        Te.value = me
        me = {
        }
        me.value = de
        de = {
        }
        ne = functions.fn_16775358({
            ge,
            i,
            y,
            g,
            U,
            fe,
        })
        de.value = We
        Ge = functions.fn_10419072({
            me,
            y,
            g,
            de,
        })
        We = {
        }
        Le = functions.fn_10556480({
            me,
            U,
            y,
            g,
        })
        We.value = Ge
        Ge = {
        }
        ke = functions.fn_4647017({
            Me,
            y,
            g,
            Z,
        })
        Ge.value = Le
        Le = {
        }
        Le.value = ke
        Ke = functions.fn_4371042({
            Le,
            y,
            g,
            i,
            Z,
            Fe,
        })
        ke = {
        }
        ke.value = Ke
        qe = functions.fn_4588745({
            Te,
            U,
            y,
            g,
            Ge,
            Z,
            Me,
            i,
            We,
            ke,
        })
        Ke = {
        }
        Ke.value = qe
        qe = {
        }
        qe.value = ne
        ve = functions.fn_6036509({
            Ze,
            i,
            y,
            g,
            ge,
            Z,
            Me,
            U,
            ze,
            Ke,
            Te,
            qe,
        })
        Ze.value = false
        ne = {
        }
        ne.value = ve
        ve = {
        }
        ve.value = Be
        Je = functions.fn_1918516({
            we,
            J,
            y,
            g,
            U,
        })
        we.value = nil
        Be = {
        }
        Be.value = Ce
        Ce = {
        }
        Ce.value = Je
        Je = {
            ['W'] = false,
            ['A'] = false,
            ['S'] = false,
            ['D'] = false,
            ['Space'] = false,
            ['LeftShift'] = false,
        }
        ae = {
        }
        ae.value = Je
        Je = a.InputBegan
        Ue = Je.Connect
        ie = functions.fn_15146232({
            y,
            g,
            ae,
        })
        Ue = Ue(Je, ie)
        ie = functions.fn_3154260({
            y,
            g,
            ae,
        })
        Je = a.InputEnded
        Ue = Je.Connect
        Ue = Ue(Je, ie)
        Ue = {
        }
        Ue.value = nil
        ie = functions.fn_13029380({
            Ue,
            B,
            y,
            g,
            Z,
            Me,
            w,
            ae,
            U,
        })
        De = functions.fn_6104603({
            Ue,
            U,
            y,
            g,
        })
        Je = {
        }
        Je.value = ie
        ie = {
        }
        ie.value = De
        Ve = B.value
        De = Ve.Heartbeat
        Ne = functions.fn_16646812({
            ve,
        })
        Ve = De.Connect
        Ve = Ve(De, Ne)
        De = env.loadstring
        Ne = env.game
        be = Ne.HttpGet
        se = {
            be(Ne, 'https://sirius.menu/rayfield'),
        }
        Ve = De(unpackValues(se))
        De = Ve()
        Ve = {
        }
        Ve.value = De
        De = Ve.value
        Ne = De.CreateWindow
        He = {
            ['Enabled'] = false,
        }
        se = {
            ['Name'] = 'IGRIS Hub',
            ['LoadingTitle'] = 'IGRIS Hub',
            ['LoadingSubtitle'] = 'Chams | Auto-Craft | Player Mods',
            ['ConfigurationSaving'] = He,
            ['KeySystem'] = false,
        }
        Ne = Ne(De, se)
        De = Ne.CreateTab
        De = De(Ne, 'Visuals', 4483362458)
        Qe = Z.value
        Ae = Qe.monsterEnabled
        se = De.CreateToggle
        Ie = functions.onMonsterChams({
            Z,
            y,
            g,
            U,
            je,
            u,
            p,
            Ve,
        })
        ce = {
            ['Name'] = 'Monster Chams',
            ['CurrentValue'] = Ae,
            ['Flag'] = 'MonsterChams',
            ['Callback'] = Ie,
        }
        se = se(De, ce)
        Qe = Z.value
        Ae = Qe.monsterFillColor
        se = De.CreateColorPicker
        Ie = functions.onMonsterFillColor({
            Z,
            y,
            g,
            je,
        })
        ce = {
            ['Name'] = 'Monster Fill Color',
            ['Color'] = Ae,
            ['Flag'] = 'MonsterFillColor',
            ['Callback'] = Ie,
        }
        se = se(De, ce)
        Qe = Z.value
        se = De.CreateColorPicker
        Ae = Qe.monsterOutlineColor
        Ie = functions.onMonsterOutlineColor({
            Z,
            y,
            g,
            je,
        })
        ce = {
            ['Name'] = 'Monster Outline Color',
            ['Color'] = Ae,
            ['Flag'] = 'MonsterOutlineColor',
            ['Callback'] = Ie,
        }
        se = se(De, ce)
        Ae = {
            0,
            1,
        }
        pe = Z.value
        oe = pe.monsterFillTransparency
        jI = functions.onMonsterTransparency({
            Z,
            y,
            g,
            je,
        })
        ce = {
            ['Name'] = 'Monster Fill Transparency',
            ['Range'] = Ae,
            ['Increment'] = 0.05,
            ['Suffix'] = '',
            ['CurrentValue'] = oe,
            ['Flag'] = 'MonsterFillTrans',
            ['Callback'] = jI,
        }
        se = De.CreateSlider
        se = se(De, ce)
        Qe = Z.value
        Ae = Qe.playerEnabled
        se = De.CreateToggle
        Ie = functions.onPlayerChams({
            Z,
            y,
            g,
            U,
            Y,
            u,
            l,
            Ve,
        })
        ce = {
            ['Name'] = 'Player Chams (others)',
            ['CurrentValue'] = Ae,
            ['Flag'] = 'PlayerChams',
            ['Callback'] = Ie,
        }
        se = se(De, ce)
        Qe = Z.value
        Ae = Qe.playerFillColor
        Ie = functions.onPlayerFillColor({
            Z,
            y,
            g,
            Y,
        })
        ce = {
            ['Name'] = 'Player Fill Color',
            ['Color'] = Ae,
            ['Flag'] = 'PlayerFillColor',
            ['Callback'] = Ie,
        }
        se = De.CreateColorPicker
        se = se(De, ce)
        Qe = Z.value
        Ae = Qe.playerOutlineColor
        Ie = functions.onPlayerOutlineColor({
            Z,
            y,
            g,
            Y,
        })
        ce = {
            ['Name'] = 'Player Outline Color',
            ['Color'] = Ae,
            ['Flag'] = 'PlayerOutlineColor',
            ['Callback'] = Ie,
        }
        se = De.CreateColorPicker
        se = se(De, ce)
        Qe = Z.value
        Ae = Qe.localEnabled
        se = De.CreateToggle
        Ie = functions.onLocalPlayerChams({
            Z,
            y,
            g,
            U,
            Y,
            u,
            Se,
            Ve,
        })
        ce = {
            ['Name'] = 'Local Player Chams',
            ['CurrentValue'] = Ae,
            ['Flag'] = 'LocalChams',
            ['Callback'] = Ie,
        }
        se = se(De, ce)
        se = De.CreateColorPicker
        Qe = Z.value
        Ae = Qe.localFillColor
        Ie = functions.onLocalFillColor({
            Z,
            y,
            g,
            Y,
        })
        ce = {
            ['Name'] = 'Local Fill Color',
            ['Color'] = Ae,
            ['Flag'] = 'LocalFillColor',
            ['Callback'] = Ie,
        }
        se = se(De, ce)
        Qe = Z.value
        Ae = Qe.debug
        se = De.CreateToggle
        Ie = functions.onDebugLogging({
            Z,
            y,
            g,
        })
        ce = {
            ['Name'] = 'Debug Logging (F9)',
            ['CurrentValue'] = Ae,
            ['Flag'] = 'DebugLog',
            ['Callback'] = Ie,
        }
        se = se(De, ce)
        se = De.CreateButton
        Ae = functions.onCleanupChams({
            H,
            U,
            y,
            g,
            Ve,
        })
        ce = {
            ['Name'] = 'Force Cleanup All Chams',
            ['Callback'] = Ae,
        }
        se = se(De, ce)
        se = Ne.CreateTab
        se = se(Ne, 'Player', 4483362458)
        ue = Z.value
        Qe = ue.infStamina
        ce = se.CreateToggle
        Ee = functions.onInfiniteStamina({
            Z,
            y,
            g,
            U,
            Ve,
        })
        be = {
            ['Name'] = 'Inf Stamina',
            ['CurrentValue'] = Qe,
            ['Flag'] = 'InfStamina',
            ['Callback'] = Ee,
        }
        ce = ce(se, be)
        ce = se.CreateToggle
        ue = Z.value
        Qe = ue.infHunger
        Ee = functions.onInfiniteHunger({
            Z,
            y,
            g,
            U,
            Ve,
        })
        be = {
            ['Name'] = 'Inf Hunger',
            ['CurrentValue'] = Qe,
            ['Flag'] = 'InfHunger',
            ['Callback'] = Ee,
        }
        ce = ce(se, be)
        ue = Z.value
        Qe = ue.infThirst
        ce = se.CreateToggle
        Ee = functions.onInfiniteThirst({
            Z,
            y,
            g,
            U,
            Ve,
        })
        be = {
            ['Name'] = 'Inf Thirst',
            ['CurrentValue'] = Qe,
            ['Flag'] = 'InfThirst',
            ['Callback'] = Ee,
        }
        ce = ce(se, be)
        ue = Z.value
        Qe = ue.flyEnabled
        ce = se.CreateToggle
        Ee = functions.onFly({
            Z,
            y,
            g,
            U,
            Je,
            ie,
            Ve,
        })
        be = {
            ['Name'] = 'Fly (WASD + Space/Shift)',
            ['CurrentValue'] = Qe,
            ['Flag'] = 'Fly',
            ['Callback'] = Ee,
        }
        ce = ce(se, be)
        Qe = {
            20,
            200,
        }
        Ye = Z.value
        pe = Ye.flySpeed
        ce = se.CreateSlider
        tI = functions.onFlySpeed({
            Z,
            y,
            g,
            U,
        })
        be = {
            ['Name'] = 'Fly Speed',
            ['Range'] = Qe,
            ['Increment'] = 10,
            ['Suffix'] = ' spd',
            ['CurrentValue'] = pe,
            ['Flag'] = 'FlySpeed',
            ['Callback'] = tI,
        }
        ce = ce(se, be)
        ce = se.CreateToggle
        ue = Z.value
        Qe = ue.noclipEnabled
        Ee = functions.onNoclip({
            Z,
            y,
            g,
            U,
            Be,
            Ce,
            Ve,
        })
        be = {
            ['Name'] = 'Noclip (walk through walls)',
            ['CurrentValue'] = Qe,
            ['Flag'] = 'Noclip',
            ['Callback'] = Ee,
        }
        ce = ce(se, be)
        Re = {
        }
        ce = Ne.CreateTab
        ce = ce(Ne, 'Auto-Craft', 4483362458)
        xe = {
        }
        Ae = functions.fn_12582954({
            xe,
            Re,
            Xe,
            y,
            g,
        })
        be = {
        }
        xe.value = be
        be = {
        }
        Re.value = be
        be = {
        }
        be.value = Ae
        Qe = Xe.value
        Ae = not Qe
        flow = Ae and 1239621 or 8640415
        if flow and flow >= 1200250 and flow < 1255983 then
            Ae = ze.value
            flow = 8640415
            Qe = Ae()
        else
        end
        Ae = be.value
        Qe = Ae()
        Qe = {
        }
        Qe.value = 'Gun'
        He = ge.value
        Ie = Qe.value
        ue = He[Ie]
        Ae = not ue
        flow = Ae and 8449276 or 11507235
        if flow and flow >= 8447518 and flow < 8450813 then
            Ae = env.ipairs
            pe = Xe.value
            Ee = pe
            flow = pe and 7312973 or 13257836
            if flow and flow >= 7310374 and flow < 7319151 then
            else
                flow = 7312973
                pe = {
                }
                Ee = pe
            end
            oe = {
                Ae(Ee),
            }
            ue = oe[1]
            He = oe[2]
            flow = 7403462
            Ie = oe[3]
            while true do
                Ie, Ee = ue(He, Ie)
                flow = Ie and 13797140 or 1580785
                if flow and flow >= 13756362 and flow < 13797408 then
                    Ye = Ee.requirements
                    oe = Ye
                    flow = Ye and 15443348 or 8964817
                    if flow and flow >= 8962050 and flow < 8977987 then
                    else
                        jI = Ee.requirements
                        le = #jI
                        Ye = le > 0
                        oe = Ye
                        flow = 8964817
                    end
                    flow = oe and 4384199 or 321648
                    if flow and flow >= 316349 and flow < 400655 then
                        flow = 7403462
                    else
                    end
                else
                end
                if flow == nil or flow < 7385673 or flow >= 7405830 then
                    break
                end
            end
            if flow and flow >= 1580272 and flow < 1601281 then
            else
                flow = 1580785
                oe = Ee.id
                Qe.value = oe
            end
            flow = 11507235
        else
        end
        Ae = functions.fn_11317066({
            ge,
            Qe,
            y,
            g,
        })
        Ye = Re.value
        jI = Ae()
        ue = ce.CreateDropdown
        PI = functions.onRecipeSelected({
            y,
            g,
            U,
            i,
            xe,
            Qe,
        })
        He = {
            ['Name'] = 'Recipe',
            ['Options'] = Ye,
            ['CurrentOption'] = jI,
            ['Flag'] = 'RecipePicker',
            ['Callback'] = PI,
        }
        ue = ue(ce, He)
        flow = nil
        le = Z.value
        Ye = le.returnToStart
        ue = ce.CreateToggle
        results = {
        }
        eI = functions.onReturnAfterCraft({
            Z,
            y,
            g,
            U,
        })
        He = {
            ['Name'] = 'Return to Start After Crafting',
            ['CurrentValue'] = Ye,
            ['Flag'] = 'ReturnToStart',
            ['Callback'] = eI,
        }
        ue = ue(ce, He)
        ue = ce.CreateButton
        Ye = functions.onAutoCraft({
            Ze,
            Ve,
            y,
            g,
            U,
            Qe,
            ge,
            Te,
            ne,
        })
        He = {
            ['Name'] = 'AUTO-CRAFT SELECTED RECIPE',
            ['Callback'] = Ye,
        }
        ue = ue(ce, He)
        ue = ce.CreateButton
        Ye = functions.onRefreshRecipes({
            ze,
            be,
            U,
            y,
            g,
            Re,
            Ve,
            Xe,
        })
        He = {
            ['Name'] = 'Refresh Recipes from Server',
            ['Callback'] = Ye,
        }
        ue = ue(ce, He)
        ue = ce.CreateButton
        Ye = functions.onShowInventory({
            ye,
            U,
            y,
            g,
            Ve,
        })
        He = {
            ['Name'] = 'Show Inventory Status (F9)',
            ['Callback'] = Ye,
        }
        ue = ue(ce, He)
        ue = ce.CreateButton
        Ye = functions.onDiagnoseMaterialNodes({
            U,
            y,
            g,
            me,
            w,
            Ve,
            Ge,
        })
        He = {
            ['Name'] = 'Diagnose Material Nodes (F9)',
            ['Callback'] = Ye,
        }
        ue = ue(ce, He)
        He = env.task
        ue = He.spawn
        Ie = functions.fn_11896162({
            y,
            g,
            je,
            Y,
            U,
            Z,
            ze,
            Xe,
            Qe,
            Ve,
        })
        He = ue(Ie)
        ue = U.value
        pe = env.game
        Ee = pe.PlaceId
        He = ue('IGRIS Hub loaded. PlaceId:', Ee)
        return unpackValues(results)
    end
end


functions.fn_118555 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local M, X, flow, g, results
        flow = 118555
        g = {
        }
        X = args[1]
        results = captures[1].value
        flow = results[X]
        g.value = flow
        flow = g.value
        flow = flow and 5952851 or 6984239
        if flow and flow >= 5940294 and flow < 5983265 then
            M = functions.fn_12036851({
                g,
            })
            flow = env.pcall
            results = flow(M)
            flow = captures[1].value
            flow[X] = nil
            flow = 6984239
        else
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.onInfiniteStamina = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5, arg6)
        local args = { arg1, arg2, arg3, arg4, arg5, arg6 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 152811
        X = args[1]
        flow = captures[1].value
        g = X
        flow.infStamina = g
        flow = captures[4].value
        results = flow('Inf stamina:', X)
        flow = captures[5].value
        M = 'Title'
        y = 'Inf Stamina'
        v = flow
        Z = 'Content'
        flow = X and 11162936 or 12377554
        w = X
        if flow and flow >= 11154048 and flow < 11168184 then
            flow = 12377554
            w = 'Stamina locked to 420 — sprint forever.'
        else
        end
        flow = w and 8811311 or 5990233
        B = w
        if flow and flow >= 5983265 and flow < 5995972 then
            flow = 8811311
            B = 'Disabled.'
        else
        end
        flow = v
        results = flow.Notify
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = results(flow, g)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_211743 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local flow, g, results
        flow = 211743
        flow = captures[1].value
        g = flow.FindFirstChild
        results = {
            g(flow, 'MaterialNodes'),
        }
        flow = nil
        results = {
            unpackValues(results),
        }
        return unpackValues(results)
    end
end


functions.onDebugLogging = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local X, flow, g, results
        flow = 624981
        X = args[1]
        flow = captures[1].value
        g = X
        flow.debug = g
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end

-- Failed to refresh recipes.
-- Recipe name map rebuilt. 
functions.onRefreshRecipes = function(captures)
    return function()
        local args = {  }
        local M, U, X, Z, flow, g, results, v, w
        flow = 712557
        flow = captures[1].value
        results = flow()
        flow = results and 10865583 or 14342263
        if flow and flow >= 10860214 and flow < 10943156 then
            flow = captures[2].value
            results = flow()
            flow = captures[3].value
            M = captures[6].value
            g = #M
            results = flow('Recipe name map rebuilt. ', g, ' recipes.')
            flow = captures[7].value
            U = captures[8].value
            w = #U
            v = w .. ' recipes.'
            Z = 'Refreshed ' .. v
            results = flow.Notify
            X = {
                ['Title'] = 'Recipes',
                ['Content'] = Z,
                ['Duration'] = 3,
            }
            results = results(flow, X)
            flow = 9221629
        else
            flow = captures[7].value
            results = flow.Notify
            X = {
                ['Title'] = 'Recipes',
                ['Content'] = 'Failed to refresh recipes.',
                ['Duration'] = 3,
            }
            results = results(flow, X)
            flow = 9221629
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.onMonsterFillColor = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5, arg6)
        local args = { arg1, arg2, arg3, arg4, arg5, arg6 }
        local X, flow, g, results
        flow = 887375
        flow = captures[1].value
        X = args[1]
        g = X
        flow.monsterFillColor = g
        results = captures[1].value
        flow = results.monsterEnabled
        flow = flow and 14486465 or 15763712
        if flow and flow >= 14468970 and flow < 14491524 then
            flow = captures[4].value
            results = flow()
            flow = 15763712
        else
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_1463441 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local X, flow, results
        flow = 1463441
        flow = captures[1].value
        flow = flow and 3387130 or 5806387
        if flow and flow >= 3384708 and flow < 3403361 then
            flow = nil
            results = {
            }
        else
            results = captures[2].value
            flow = results.Stepped
            X = functions.fn_4586729({
                captures[5],
                captures[3],
                captures[4],
            })
            results = flow.Connect
            results = results(flow, X)
            captures[1].value = results
            flow = captures[6].value
            results = {
            }
            X = flow('Noclip started')
            flow = nil
        end
        return unpackValues(results)
    end
end

-- HumanoidRootPart
functions.fn_1918516 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local B, M, U, X, Z, flow, g, results, w, y
        flow = 1918516
        flow = captures[1].value
        flow = flow and 2736338 or 10807627
        if flow and flow >= 2727385 and flow < 2739084 then
            flow = captures[1].value
            results = flow.Disconnect
            results = results(flow)
            captures[1].value = nil
            flow = 10807627
        else
        end
        X = captures[2].value
        results = X.Character
        X = results
        flow = X and 3150484 or 11952195
        if flow and flow >= 3147717 and flow < 3153723 then
            flow = 12929206
            results = env.ipairs
            B = X.GetDescendants
            Z = {
                B(X),
            }
            B = {
                results(unpackValues(Z)),
            }
            g = B[1]
            M = B[2]
            y = B[3]
            while true do
                y, B = g(M, y)
                flow = y and 3292533 or 7902053
                if flow and flow >= 3292504 and flow < 3314560 then
                    w = B.IsA
                    w = w(B, 'BasePart')
                    flow = w and 9955657 or 1092498
                    results = w
                    if flow and flow >= 1087489 and flow < 1120568 then
                    else
                        flow = 1092498
                        U = B.Name
                        w = U ~= 'HumanoidRootPart'
                        results = w
                    end
                    flow = results and 11568837 or 9841108
                    if flow and flow >= 9836754 and flow < 9841232 then
                    else
                        flow = 9841108
                        B.CanCollide = true
                    end
                    flow = 12929206
                else
                end
                if flow == nil or flow < 12928926 or flow >= 12940380 then
                    break
                end
            end
            flow = 11952195
        else
        end
        results = captures[5].value
        flow = nil
        g = results('Noclip stopped')
        results = {
        }
        return unpackValues(results)
    end
end


functions.onInfiniteThirst = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 1919863
        flow = captures[1].value
        X = args[1]
        g = X
        flow.infThirst = g
        flow = captures[4].value
        results = flow('Inf thirst:', X)
        flow = captures[5].value
        M = 'Title'
        y = 'Inf Thirst'
        Z = 'Content'
        v = flow
        w = X
        flow = X and 9485405 or 4777048
        if flow and flow >= 4770609 and flow < 4778004 then
        else
            flow = 4777048
            w = 'Thirst locked to 100 — never dehydrate.'
        end
        flow = w and 9080675 or 15975612
        B = w
        if flow and flow >= 9062744 and flow < 9097240 then
        else
            flow = 9080675
            B = 'Disabled.'
        end
        flow = v
        results = flow.Notify
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = results(flow, g)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_2256532 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local B, C, M, U, X, Z, flow, g, results, v, w, y
        flow = 2256532
        flow = {
        }
        X = flow
        flow = env.ipairs
        y = captures[1].value
        B = y.GetChildren
        Z = {
            B(y),
        }
        y = {
            flow(unpackValues(Z)),
        }
        flow = 11917195
        results = y[1]
        M = y[3]
        g = y[2]
        y = results
        while true do
            M, B = y(g, M)
            flow = M and 6100838 or 7909666
            if flow and flow >= 6100354 and flow < 6101113 then
                U = B.Name
                C = captures[4].value
                w = U == C
                flow = w and 3349229 or 14193748
                v = w
                if flow and flow >= 3314560 and flow < 3350417 then
                    w = B.IsA
                    w = w(B, 'Model')
                    flow = 14193748
                    v = w
                else
                end
                flow = v and 1285494 or 12543613
                if flow and flow >= 1255983 and flow < 1287724 then
                    flow = B.FindFirstChildOfClass
                    flow = flow(B, 'Humanoid')
                    flow = flow and 5194585 or 6634457
                    if flow and flow >= 5139254 and flow < 5242322 then
                        v = env.table
                        flow = v.insert
                        v = flow(X, B)
                        flow = 6634457
                    else
                    end
                    flow = 12543613
                else
                end
                flow = 11917195
            else
            end
            if flow == nil or flow < 11913588 or flow >= 11939031 then
                break
            end
        end
        flow = nil
        results = {
            X,
        }
        return unpackValues(results)
    end
end


functions.fn_2393450 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local X, flow, results
        flow = 2393450
        flow = captures[1].value
        X = flow.InvokeServer
        results = {
            X(flow),
        }
        flow = nil
        results = {
            unpackValues(results),
        }
        return unpackValues(results)
    end
end

-- GetRecipes InvokeServer error:
-- GetRecipes returned non-table:
-- recipes from server
functions.fn_2560884 = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local B, C, M, U, X, Z, flow, g, results, v, w, y
        flow = 2560884
        g = functions.fn_2393450({
            captures[1],
        })
        flow = env.pcall
        M = {
            flow(g),
        }
        X = M[2]
        results = M[1]
        g = results
        flow = not g
        flow = flow and 4105211 or 9855983
        if flow and flow >= 4103945 and flow < 4108561 then
            flow = captures[2].value
            y = env.tostring
            Z = {
                y(X),
            }
            results = flow('GetRecipes InvokeServer error:', unpackValues(Z))
            results = {
                false,
            }
            flow = nil
        else
            results = env.type
            M = results(X)
            flow = M ~= 'table'
            flow = flow and 4457332 or 5636652
            if flow and flow >= 4424402 and flow < 4469526 then
                flow = captures[2].value
                y = env.type
                Z = {
                    y(X),
                }
                results = flow('GetRecipes returned non-table:', unpackValues(Z))
                results = {
                    false,
                }
                flow = nil
            else
                flow = X
                captures[5].value = flow
                results = {
                }
                captures[6].value = results
                flow = 5043072
                M = env.ipairs
                v = {
                    M(X),
                }
                B = v[3]
                y = v[1]
                Z = v[2]
                while true do
                    B, v = y(Z, B)
                    flow = B and 14935313 or 4304427
                    if flow and flow >= 14893110 and flow < 14973521 then
                        w = captures[6].value
                        flow = 5043072
                        U = v.id
                        C = v
                        w[U] = C
                    else
                    end
                    if flow == nil or flow < 5020640 or flow >= 5045260 then
                        break
                    end
                end
                M = captures[7].value
                flow = nil
                B = #X
                y = M('Fetched', B, 'recipes from server')
                results = {
                    true,
                }
            end
        end
        return unpackValues(results)
    end
end


functions.fn_2996993 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local X, flow, g, results
        flow = 2996993
        X = args[1]
        flow = X.Character
        flow = flow and 4602539 or 4559264
        if flow and flow >= 4545859 and flow < 4570856 then
        else
            flow = captures[3].value
            g = X.Character
            results = flow(g)
            flow = 4559264
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_3154260 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local M, X, flow, g, results
        flow = 3154260
        X = args[1]
        results = X.KeyCode
        flow = results.Name
        g = flow
        M = captures[3].value
        results = M[g]
        flow = results ~= nil
        flow = flow and 11415540 or 5290127
        if flow and flow >= 5286035 and flow < 5339470 then
        else
            flow = captures[3].value
            flow[g] = false
            flow = 5290127
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_3155984 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local B, M, X, Z, flow, g, results, v, y
        flow = 3155984
        flow = env.pairs
        M = captures[1].value
        y = {
            flow(M),
        }
        g = y[3]
        results = y[1]
        X = y[2]
        M = results
        flow = 6745535
        while true do
            g, Z = M(X, g)
            flow = g and 6686003 or 8635505
            if flow and flow >= 6685601 and flow < 6692583 then
                flow = {
                }
                flow.value = Z
                Z = flow
                v = functions.fn_14211538({
                    Z,
                })
                flow = env.pcall
                B = flow(v)
                flow = 6745535
            else
            end
            if flow == nil or flow < 6741604 or flow >= 6776846 then
                break
            end
        end
        X = env.table
        results = {
        }
        flow = X.clear
        g = captures[1].value
        X = flow(g)
        flow = nil
        return unpackValues(results)
    end
end

-- Fly speed set to:
functions.onFlySpeed = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local X, flow, g, results
        flow = 3277019
        flow = captures[1].value
        X = args[1]
        g = X
        flow.flySpeed = g
        flow = captures[4].value
        results = flow('Fly speed set to:', X)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_3427359 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local M, X, flow, g, results, y
        flow = 3427359
        flow = captures[1].value
        X = args[1]
        results = flow()
        g = results
        flow = not g
        flow = flow and 14871229 or 2685154
        if flow and flow >= 2676181 and flow < 2727385 then
            flow = g.FindFirstChild
            flow = flow(g, X)
            M = flow
            flow = M and 7085605 or 8451744
            results = M
            if flow and flow >= 7085502 and flow < 7092257 then
                flow = 8451744
                y = M.IsA
                y = y(M, 'IntValue')
                results = y
            else
            end
            flow = results and 8447241 or 9303224
            if flow and flow >= 8423756 and flow < 8447518 then
                flow = M.Value
                results = {
                    flow,
                }
                flow = nil
            else
                results = {
                    0,
                }
                flow = nil
            end
        else
            results = {
                0,
            }
            flow = nil
        end
        return unpackValues(results)
    end
end

-- Failed to create highlight for
functions.fn_3455247 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
        local args = { arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 }
        local B, C, J, M, U, X, Z, a, flow, g, i, results, v, w, y
        flow = 3455247
        X = {
        }
        X.value = args[1]
        g = {
        }
        y = {
        }
        M = {
        }
        Z = {
        }
        g.value = args[2]
        M.value = args[3]
        y.value = args[4]
        Z.value = args[5]
        B = {
        }
        B.value = args[6]
        w = X.value
        v = not w
        flow = v and 9745867 or 3244962
        results = v
        if flow and flow >= 3213941 and flow < 3256579 then
            U = X.value
            w = U.Parent
            flow = 9745867
            v = not w
            results = v
        else
        end
        flow = results and 1822857 or 13210234
        if flow and flow >= 1795597 and flow < 1848721 then
            results = {
                nil,
            }
            flow = nil
        else
            results = captures[3].value
            v = X.value
            flow = results[v]
            flow = flow and 6147498 or 15734456
            if flow and flow >= 6142505 and flow < 6148015 then
                v = functions.fn_14509896({
                    captures[3],
                    X,
                })
                flow = env.pcall
                results = flow(v)
                flow = captures[3].value
                results = X.value
                flow[results] = nil
                flow = 15734456
            else
            end
            w = functions.fn_14061792({
                captures[1],
                captures[2],
                g,
                X,
                M,
                y,
                Z,
                B,
                captures[4],
            })
            flow = env.pcall
            U = {
                flow(w),
            }
            v = U[2]
            results = U[1]
            w = results
            flow = w and 12415116 or 13620805
            results = w
            if flow and flow >= 12406474 and flow < 12415268 then
                results = v
                flow = 13620805
            else
            end
            flow = results and 10202387 or 15256472
            if flow and flow >= 10170984 and flow < 10207016 then
                U = v
                flow = captures[3].value
                results = X.value
                flow[results] = U
                flow = nil
                results = {
                    v,
                }
            else
                flow = captures[5].value
                C = env.tostring
                J = X.value
                a = C(J)
                J = env.tostring
                i = {
                    J(v),
                }
                results = flow('Failed to create highlight for', a, '—', unpackValues(i))
                results = {
                    nil,
                }
                flow = nil
            end
        end
        return unpackValues(results)
    end
end

-- Dropdown callback received:
-- Recipe selected (fuzzy match):
-- Could not find recipe for name:
-- Dropdown callback got non-string:
functions.onRecipeSelected = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5, arg6)
        local args = { arg1, arg2, arg3, arg4, arg5, arg6 }
        local B, C, M, U, X, Z, flow, g, i, results, v, w, y
        flow = 3675260
        X = args[1]
        results = env.type
        g = results(X)
        flow = g == 'table'
        flow = flow and 2743476 or 9596565
        if flow and flow >= 2739084 and flow < 2746960 then
            g = X[1]
            flow = g and 132321 or 155879
            results = g
            if flow and flow >= 120570 and flow < 135217 then
            else
                y = X[2]
                g = y
                flow = y and 13953020 or 10146938
                if flow and flow >= 10134671 and flow < 10159729 then
                    flow = 13953020
                    y = X[3]
                    g = y
                else
                end
                results = g
                flow = 132321
            end
            X = results
            flow = 9596565
        else
        end
        flow = captures[3].value
        y = env.tostring
        Z = {
            y(X),
        }
        g = flow('Dropdown callback received:', unpackValues(Z))
        M = not X
        flow = M and 8813069 or 1713107
        g = M
        if flow and flow >= 1680782 and flow < 1729743 then
            y = env.type
            Z = y(X)
            flow = 8813069
            M = Z ~= 'string'
            g = M
        else
        end
        flow = g and 2034755 or 6140620
        if flow and flow >= 1952074 and flow < 2074701 then
            flow = captures[4].value
            results = {
            }
            y = env.type
            Z = {
                y(X),
            }
            g = flow('Dropdown callback got non-string:', unpackValues(Z))
            flow = nil
        else
            g = captures[5].value
            flow = g[X]
            g = flow
            flow = g and 2651903 or 3420399
            if flow and flow >= 2641514 and flow < 2676181 then
                flow = g
                captures[6].value = flow
                M = captures[3].value
                flow = 3351279
                v = X .. ')'
                y = M('Recipe selected:', g, '(name:', v)
                results = {
                }
                flow = nil
            else
                flow = 1440608
                M = env.pairs
                v = captures[5].value
                w = {
                    M(v),
                }
                Z = w[2]
                B = w[3]
                y = w[1]
                while true do
                    B, v = y(Z, B)
                    flow = B and 14491816 or 6327164
                    if flow and flow >= 14491524 and flow < 14504210 then
                        M = B
                        C = M.find
                        C = C(M, X, 1, true)
                        w = C
                        flow = C and 458075 or 11037173
                        if flow and flow >= 435749 and flow < 462509 then
                        else
                            flow = 458075
                            C = X.find
                            C = C(X, M, 1, true)
                            w = C
                        end
                        flow = w and 11169495 or 6483044
                        if flow and flow >= 6481016 and flow < 6487381 then
                            flow = 1440608
                        else
                        end
                    else
                    end
                    if flow == nil or flow < 1433040 or flow >= 1442747 then
                        break
                    end
                end
                if flow and flow >= 6323909 and flow < 6338093 then
                    M = captures[4].value
                    flow = 3351279
                    B = env.tostring
                    v = {
                        B(X),
                    }
                    y = M('Could not find recipe for name:', unpackValues(v))
                    results = {
                    }
                    flow = nil
                else
                    w = v
                    captures[6].value = w
                    U = captures[3].value
                    results = {
                    }
                    flow = nil
                    i = M .. ')'
                    C = U('Recipe selected (fuzzy match):', v, '(name:', i)
                end
            end
        end
        return unpackValues(results)
    end
end


functions.fn_3907422 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local flow, results
        flow = 3907422
        flow = captures[1].value
        results = flow.Destroy
        results = results(flow)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end

-- Collision restored.
functions.onNoclip = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 4103902
        X = args[1]
        flow = captures[1].value
        g = X
        flow.noclipEnabled = g
        flow = captures[4].value
        results = flow('Noclip:', X)
        flow = X and 10944365 or 16296930
        if flow and flow >= 10943156 and flow < 10953669 then
            flow = captures[5].value
            results = flow()
            flow = 7288514
        else
            flow = captures[6].value
            results = flow()
            flow = 7288514
        end
        flow = captures[7].value
        M = 'Title'
        y = 'Noclip'
        v = flow
        Z = 'Content'
        w = X
        flow = X and 12194735 or 10551936
        if flow and flow >= 10511068 and flow < 10552117 then
        else
            flow = 10551936
            w = 'Collision disabled — walk through anything.'
        end
        B = w
        flow = w and 5100789 or 10493017
        if flow and flow >= 5083888 and flow < 5101989 then
        else
            flow = 5100789
            B = 'Collision restored.'
        end
        flow = v
        results = flow.Notify
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = results(flow, g)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_4196080 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local X, flow, g, results
        flow = 4196080
        flow = captures[1].value
        g = captures[2].value
        results = flow.FireServer
        X = g.instance
        results = results(flow, X)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.debugLog = function(captures)
    return function(...)
        local args = { ... }
        local X, flow, results
        flow = 4314615
        results = captures[1].value
        X = {
            selectValues(1, unpackValues(args)),
        }
        flow = results.debug
        flow = flow and 10747367 or 10745441
        if flow and flow >= 10735772 and flow < 10745484 then
        else
            flow = env.warn
            results = flow('[IGRIS]', unpackValues(X))
            flow = 10745441
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end

-- GatherMaterial FireServer error:
functions.fn_4371042 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local B, M, X, Z, flow, g, results, y
        flow = 4371042
        X = {
        }
        X.value = args[1]
        results = captures[1].value
        y = X.value
        M = y.position
        g = results(M)
        flow = not g
        flow = flow and 15729758 or 15596070
        if flow and flow >= 15581455 and flow < 15626300 then
            g = captures[5].value
            results = g.teleportSettle
            flow = results > 0
            flow = flow and 3376531 or 14285271
            if flow and flow >= 3365995 and flow < 3376623 then
                results = env.task
                flow = results.wait
                M = captures[5].value
                g = M.teleportSettle
                results = flow(g)
                flow = 14285271
            else
            end
            flow = env.pcall
            M = functions.fn_4196080({
                captures[6],
                X,
                captures[2],
                captures[3],
            })
            y = {
                flow(M),
            }
            results = y[1]
            g = y[2]
            M = results
            flow = not M
            flow = flow and 15008592 or 11961020
            if flow and flow >= 11953106 and flow < 11968270 then
                results = {
                    true,
                }
                flow = nil
            else
                flow = captures[4].value
                Z = env.tostring
                B = {
                    Z(g),
                }
                results = flow('GatherMaterial FireServer error:', unpackValues(B))
                results = {
                    false,
                }
                flow = nil
            end
        else
            flow = captures[4].value
            results = flow('Teleport failed — character lost')
            results = {
                false,
            }
            flow = nil
        end
        return unpackValues(results)
    end
end


functions.onPlayerChams = function(captures)
    return function(arg1)
        local args = { arg1 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 4483161
        flow = captures[1].value
        X = args[1]
        g = X
        flow.playerEnabled = g
        flow = captures[4].value
        results = flow('Player chams:', X)
        flow = X and 10805839 or 6631609
        if flow and flow >= 6628222 and flow < 6632003 then
            flow = captures[6].value
            g = captures[7].value
            results = flow(g)
            flow = 12352867
        else
            flow = captures[5].value
            results = flow()
            flow = 12352867
        end
        flow = captures[8].value
        M = 'Title'
        y = 'Player Chams'
        Z = 'Content'
        w = X
        v = flow
        flow = X and 2612959 or 13866633
        if flow and flow >= 2608799 and flow < 2613683 then
            flow = 13866633
            w = 'Enabled — other players highlighted in green.'
        else
        end
        B = w
        flow = w and 7377566 or 14202893
        if flow and flow >= 7374413 and flow < 7385673 then
        else
            flow = 7377566
            B = 'Disabled.'
        end
        flow = v
        results = flow.Notify
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = results(flow, g)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_4498933 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local B, C, D, J, M, U, X, Z, a, flow, i, results, v, w, y
        flow = 4498933
        X = captures[1].value
        results = X.flyEnabled
        flow = not results
        flow = flow and 1525819 or 9260952
        if flow and flow >= 1504012 and flow < 1535112 then
            flow = nil
            results = {
            }
        else
            flow = captures[4].value
            M = {
                flow(),
            }
            X = M[2]
            flow = not X
            flow = flow and 11581086 or 4571441
            if flow and flow >= 4570856 and flow < 4571491 then
                results = captures[5].value
                flow = results.CurrentCamera
                y = flow
                flow = not y
                flow = flow and 13366998 or 3077802
                if flow and flow >= 3055763 and flow < 3078180 then
                    results = env.Vector3
                    flow = results.new
                    results = flow(0, 0, 0)
                    Z = results
                    results = captures[6].value
                    flow = results.W
                    flow = flow and 6534261 or 12197220
                    if flow and flow >= 6527953 and flow < 6547285 then
                        B = y.CFrame
                        results = B.LookVector
                        flow = Z + results
                        Z = flow
                        flow = 12197220
                    else
                    end
                    B = captures[6].value
                    results = B.S
                    flow = results and 3449437 or 3795113
                    if flow and flow >= 3448751 and flow < 3451952 then
                        v = y.CFrame
                        B = v.LookVector
                        results = Z - B
                        flow = 3795113
                        Z = results
                    else
                    end
                    v = captures[6].value
                    B = v.A
                    flow = B and 16290096 or 2156021
                    if flow and flow >= 2154386 and flow < 2156478 then
                    else
                        w = y.CFrame
                        flow = 2156021
                        v = w.RightVector
                        B = Z - v
                        Z = B
                    end
                    w = captures[6].value
                    v = w.D
                    flow = v and 2419484 or 4113173
                    if flow and flow >= 2399608 and flow < 2420232 then
                        U = y.CFrame
                        flow = 4113173
                        w = U.RightVector
                        v = Z + w
                        Z = v
                    else
                    end
                    U = captures[6].value
                    w = U.Space
                    flow = w and 8826752 or 3868748
                    if flow and flow >= 3843718 and flow < 3868879 then
                    else
                        C = env.Vector3
                        flow = 3868748
                        U = C.new
                        C = U(0, 1, 0)
                        w = Z + C
                        Z = w
                    end
                    C = captures[6].value
                    U = C.LeftShift
                    flow = U and 12723552 or 14212517
                    if flow and flow >= 12710326 and flow < 12723920 then
                        flow = 14212517
                        a = env.Vector3
                        C = a.new
                        a = C(0, 1, 0)
                        U = Z - a
                        Z = U
                    else
                    end
                    a = Z.Magnitude
                    C = a > 0
                    flow = C and 10754152 or 6024067
                    if flow and flow >= 6018932 and flow < 6024619 then
                    else
                        C = Z.Unit
                        Z = C
                        flow = 6024067
                    end
                    D = captures[1].value
                    i = D.flySpeed
                    J = Z * i
                    X.AssemblyLinearVelocity = J
                    J = Z.Magnitude
                    a = J == 0
                    flow = a and 2613848 or 15801354
                    if flow and flow >= 2613683 and flow < 2619087 then
                        i = env.Vector3
                        flow = 15801354
                        J = i.new
                        i = J(0, 0, 0)
                        X.AssemblyLinearVelocity = i
                    else
                    end
                    flow = nil
                    results = {
                    }
                else
                    results = {
                    }
                    flow = nil
                end
            else
                flow = nil
                results = {
                }
            end
        end
        return unpackValues(results)
    end
end


functions.fn_4586729 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local B, M, X, Z, flow, g, results, y
        flow = 4586729
        results = captures[1].value
        flow = results.Character
        X = flow
        flow = not X
        flow = flow and 137987 or 2998259
        if flow and flow >= 135217 and flow < 138180 then
            flow = nil
            results = {
            }
        else
            Z = X.GetDescendants
            flow = env.ipairs
            y = {
                Z(X),
            }
            Z = {
                flow(unpackValues(y)),
            }
            flow = 14630623
            results = Z[1]
            y = results
            M = Z[3]
            g = Z[2]
            while true do
                M, B = y(g, M)
                flow = M and 16108194 or 14874544
                if flow and flow >= 16081125 and flow < 16114320 then
                    flow = B.IsA
                    flow = flow(B, 'BasePart')
                    flow = flow and 12561970 or 2251730
                    if flow and flow >= 2206967 and flow < 2253415 then
                    else
                        B.CanCollide = false
                        flow = 2251730
                    end
                    flow = 14630623
                else
                end
                if flow == nil or flow < 14629805 or flow >= 14657102 then
                    break
                end
            end
            flow = nil
            results = {
            }
        end
        return unpackValues(results)
    end
end

-- Character lost during gather
-- === %s COMPLETE: %d/%d ===
-- === GATHER %s: need %d, have %d ===
--   Round %d: gained %d %s (now %d/%d)
functions.fn_4588745 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local B, C, D, J, M, N, R, U, V, X, Z, a, b, c, flow, g, i, results, s, v, w, x, y
        flow = 4588745
        X = args[1]
        g = args[2]
        flow = captures[1].value
        results = flow(X)
        M = results
        flow = M >= g
        flow = flow and 13132276 or 12415333
        if flow and flow >= 12415268 and flow < 12483206 then
            flow = captures[2].value
            Z = env.string
            y = Z.format
            Z = {
                y('=== GATHER %s: need %d, have %d ===', X, g, M),
            }
            results = flow(unpackValues(Z))
            flow = captures[5].value
            results = flow()
            Z = captures[6].value
            flow = 9293963
            y = Z.maxRescanRounds
            Z = y
            B = 1
            v = 1 < 0
            y = 1 - 1
            while true do
                w = not v
                y = y + B
                results = y <= Z
                results = w and results
                w = y >= Z
                w = v and w
                results = w or results
                flow = results and 912230
                flow = flow or 13526529
                if flow and flow >= 897075 and flow < 989688 then
                    flow = captures[7].value
                    C = {
                        flow(),
                    }
                    U = C[2]
                    w = y
                    flow = not U
                    flow = flow and 896480 or 10972606
                    if flow and flow >= 10953669 and flow < 10978098 then
                        flow = captures[9].value
                        a = U.Position
                        results = flow(X, a)
                        a = results
                        results = #a
                        flow = results == 0
                        flow = flow and 3990718 or 3364782
                        if flow and flow >= 3355035 and flow < 3365995 then
                            flow = captures[2].value
                            i = env.string
                            J = i.format
                            V = #a
                            i = {
                                J('Round %d: found %d %s nodes — teleport-gathering', w, V, X),
                            }
                            results = flow(unpackValues(i))
                            flow = captures[1].value
                            results = flow(X)
                            J = results
                            flow = env.ipairs
                            V = {
                                flow(a),
                            }
                            i = V[2]
                            flow = 7506878
                            results = V[1]
                            D = V[3]
                            V = results
                            while true do
                                D, s = V(i, D)
                                flow = D and 6355597 or 1889293
                                if flow and flow >= 6347124 and flow < 6368820 then
                                    x = s.instance
                                    b = not x
                                    flow = b and 14286716 or 16182441
                                    N = b
                                    if flow and flow >= 14286553 and flow < 14332470 then
                                    else
                                        R = s.instance
                                        x = R.Parent
                                        b = not x
                                        flow = 14286716
                                        N = b
                                    end
                                    flow = N and 642348 or 5531841
                                    if flow and flow >= 637546 and flow < 689319 then
                                        flow = 8929592
                                        flow = 7506878
                                    else
                                        flow = captures[10].value
                                        N = flow(s)
                                        b = captures[6].value
                                        N = b.postFireSettle
                                        flow = N > 0
                                        flow = flow and 14825804 or 44114
                                        if flow and flow >= 24117 and flow < 45484 then
                                        else
                                            N = env.task
                                            flow = N.wait
                                            x = captures[6].value
                                            b = x.postFireSettle
                                            N = flow(b)
                                            flow = 44114
                                        end
                                        N = captures[1].value
                                        b = N(X)
                                        flow = b >= g
                                        flow = flow and 13570644 or 1554579
                                        if flow and flow >= 1554515 and flow < 1554637 then
                                            flow = 8929592
                                            flow = 7506878
                                        else
                                        end
                                    end
                                else
                                end
                                if flow == nil or flow < 7474940 or flow >= 7509101 then
                                    break
                                end
                            end
                            if flow and flow >= 1883082 and flow < 1900044 then
                            else
                                flow = 1889293
                            end
                            flow = captures[1].value
                            i = flow(X)
                            flow = i - J
                            D = flow
                            flow = captures[2].value
                            s = env.string
                            c = s.format
                            s = {
                                c('  Round %d: gained %d %s (now %d/%d)', w, D, X, i, g),
                            }
                            V = flow(unpackValues(s))
                            flow = i >= g
                            flow = flow and 2451059 or 9021193
                            if flow and flow >= 9007334 and flow < 9062744 then
                                flow = D == 0
                                flow = flow and 8769536 or 15788351
                                if flow and flow >= 8751507 and flow < 8776805 then
                                    flow = captures[8].value
                                    s = env.string
                                    c = s.format
                                    R = captures[6].value
                                    x = R.respawnWait
                                    b = x * 2
                                    s = {
                                        c('  No gain this round — server may be rate-limiting. Waiting %.1fs', b),
                                    }
                                    V = flow(unpackValues(s))
                                    V = env.task
                                    flow = V.wait
                                    N = captures[6].value
                                    s = N.respawnWait
                                    c = s * 2
                                    V = flow(c)
                                    flow = 15497297
                                else
                                    V = env.task
                                    flow = V.wait
                                    s = captures[6].value
                                    c = s.respawnWait
                                    V = flow(c)
                                    flow = 15497297
                                end
                                flow = 8945730
                                flow = 9293963
                            else
                            end
                        else
                            flow = captures[2].value
                            results = flow('No', X, 'nodes available — waiting for respawn...')
                            results = env.task
                            flow = results.wait
                            i = captures[6].value
                            J = i.respawnWait
                            results = flow(J)
                            flow = 8945730
                            flow = 9293963
                        end
                    else
                    end
                else
                end
                if flow == nil or flow < 9276521 or flow >= 9302672 then
                    break
                end
            end
            if flow and flow >= 896132 and flow < 897075 then
                flow = captures[8].value
                results = flow('Character lost during gather')
                results = {
                    false,
                }
                flow = nil
            elseif flow and flow >= 2442126 and flow < 2452911 then
                flow = captures[2].value
                s = env.string
                c = s.format
                s = {
                    c('=== %s COMPLETE: %d/%d ===', X, i, g),
                }
                V = flow(unpackValues(s))
                results = {
                    true,
                }
                flow = nil
            else
                flow = captures[1].value
                y = flow(X)
                flow = captures[2].value
                v = env.string
                B = v.format
                v = {
                    B('=== %s GIVE UP: %d/%d ===', X, y, g),
                }
                Z = flow(unpackValues(v))
                flow = y >= g
                results = {
                    flow,
                }
                flow = nil
            end
        else
            flow = captures[2].value
            Z = env.string
            y = Z.format
            Z = {
                y('Already have %d/%d %s — skipping', M, g, X),
            }
            results = flow(unpackValues(Z))
            results = {
                true,
            }
            flow = nil
        end
        return unpackValues(results)
    end
end


functions.fn_4647017 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local B, M, X, Z, flow, g, results, v, y
        flow = 4647017
        flow = captures[1].value
        X = args[1]
        M = {
            flow(),
        }
        g = M[2]
        flow = not g
        flow = flow and 4413377 or 9236010
        if flow and flow >= 4397306 and flow < 4424402 then
            results = {
                false,
            }
            flow = nil
        else
            y = env.Vector3
            results = y.new
            v = captures[4].value
            B = v.teleportHeightOffset
            y = results(0, B, 0)
            flow = X + y
            y = flow
            Z = env.CFrame
            results = Z.new
            Z = results(y)
            g.CFrame = Z
            results = {
                true,
            }
            flow = nil
        end
        return unpackValues(results)
    end
end


functions.fn_4648727 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local M, X, flow, g, results
        flow = 4648727
        X = args[1]
        g = not X
        flow = g and 15294899 or 6790592
        results = g
        if flow and flow >= 6776846 and flow < 6845722 then
            flow = 15294899
            M = X.Parent
            g = not M
            results = g
        else
        end
        flow = results and 5704953 or 11321247
        if flow and flow >= 5704953 and flow < 5704958 then
            results = {
                nil,
            }
            flow = nil
        else
            flow = X.IsA
            flow = flow(X, 'BasePart')
            flow = flow and 9869544 or 11290483
            if flow and flow >= 9864547 and flow < 9876140 then
                flow = X.Position
                results = {
                    flow,
                }
                flow = nil
            else
                flow = X.IsA
                flow = flow(X, 'Model')
                flow = flow and 11151570 or 6715523
                if flow and flow >= 6692583 and flow < 6734552 then
                    results = {
                        nil,
                    }
                    flow = nil
                else
                    flow = X.FindFirstChildWhichIsA
                    flow = flow(X, 'BasePart', true)
                    g = flow
                    flow = g and 4897746 or 9437026
                    if flow and flow >= 4896309 and flow < 4913914 then
                        flow = g.Position
                        results = {
                            flow,
                        }
                        flow = nil
                    else
                        flow = X.PrimaryPart
                        M = flow
                        flow = M and 15341245 or 10167079
                        if flow and flow >= 10159729 and flow < 10170984 then
                            flow = 6715523
                            results = {
                                nil,
                            }
                            flow = nil
                        else
                            flow = M.Position
                            results = {
                                flow,
                            }
                            flow = nil
                        end
                    end
                end
            end
        end
        return unpackValues(results)
    end
end


functions.fn_4782885 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local flow, g, results
        flow = 4782885
        results = env.Instance
        flow = results.new
        results = flow('Folder')
        captures[3].value = results
        flow = captures[3].value
        flow.Name = 'UGC_Chams_Root'
        flow = captures[3].value
        results = {
        }
        g = captures[4].value
        flow.Parent = g
        flow = nil
        return unpackValues(results)
    end
end

-- All chams force-cleared
-- All highlights cleared.
functions.onCleanupChams = function(captures)
    return function(arg1)
        local args = { arg1 }
        local X, flow, results
        flow = 5104597
        flow = captures[1].value
        results = flow()
        flow = captures[2].value
        results = flow('All chams force-cleared')
        flow = captures[5].value
        results = flow.Notify
        X = {
            ['Title'] = 'Chams',
            ['Content'] = 'All highlights cleared.',
            ['Duration'] = 3,
        }
        results = results(flow, X)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_5522947 = function(captures)
    return function()
        local args = {  }
        local X, flow, results
        flow = 5522947
        flow = captures[1].value
        X = captures[2].value
        results = flow.FireServer
        results = results(flow, X)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end

-- Saved start position:
-- Exceeded max runtime
-- CraftItem fire failed
-- ########## AUTO-CRAFT START: %s ##########
functions.fn_6036509 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local A, B, C, D, E, H, I, J, M, N, Q, R, U, V, X, Z, a, b, c, ee, flow, g, i, o, p, results, s, u, v, w, x, y
        flow = 6036509
        X = args[1]
        g = args[2]
        flow = captures[1].value
        flow = flow and 3742989 or 14091178
        if flow and flow >= 3740537 and flow < 3763113 then
            flow = captures[2].value
            results = flow('Auto-craft already running — ignoring request')
            results = {
            }
            flow = nil
        else
            results = captures[5].value
            flow = results[X]
            M = flow
            flow = not M
            flow = flow and 806732 or 2115468
            if flow and flow >= 762329 and flow < 849034 then
                flow = captures[2].value
                results = flow('Recipe not found:', X)
                flow = g and 11414203 or 2488923
                if flow and flow >= 2477386 and flow < 2502702 then
                else
                    flow = g(false, 'Recipe not found')
                    flow = 2488923
                end
                results = {
                }
                flow = nil
            else
                results = captures[6].value
                y = nil
                flow = results.returnToStart
                flow = flow and 11979219 or 8840716
                if flow and flow >= 8834704 and flow < 8842752 then
                else
                    flow = captures[7].value
                    B = {
                        flow(),
                    }
                    Z = B[2]
                    flow = Z and 8403717 or 16586047
                    if flow and flow >= 8400388 and flow < 8408243 then
                        flow = Z.CFrame
                        results = captures[8].value
                        y = flow
                        U = env.tostring
                        a = y.Position
                        C = {
                            U(a),
                        }
                        flow = 14737665
                        v = results('Saved start position:', unpackValues(C))
                    else
                        results = captures[2].value
                        flow = 14737665
                        v = results('Could not save start position — character not found')
                    end
                    flow = 8840716
                end
                captures[1].value = true
                v = nil
                Z = env.tick
                B = Z()
                w = captures[8].value
                Z = false
                a = env.string
                C = a.format
                i = M.name
                a = {
                    C('########## AUTO-CRAFT START: %s ##########', i),
                }
                U = w(unpackValues(a))
                w = captures[9].value
                U = w()
                U = captures[5].value
                w = U[X]
                M = w
                U = not M
                flow = U and 12597319 or 6964802
                if flow and flow >= 6943590 and flow < 6971224 then
                    C = env.ipairs
                    flow = 1335968
                    D = M.requirements
                    V = {
                        C(D),
                    }
                    a = V[1]
                    J = V[2]
                    i = V[3]
                    while true do
                        i, D = a(J, i)
                        flow = i and 2140758 or 7752625
                        if flow and flow >= 2139906 and flow < 2154386 then
                            s = env.tick
                            N = s()
                            c = N - B
                            N = captures[6].value
                            s = N.maxRuntimeSec
                            V = c > s
                            flow = V and 101207 or 13315187
                            if flow and flow >= 13313472 and flow < 13349626 then
                                N = captures[8].value
                                R = env.string
                                x = R.format
                                Q = D.item
                                u = D.amount
                                R = {
                                    x('--- Gathering %s x%d ---', Q, u),
                                }
                                b = N(unpackValues(R))
                                N = captures[10].value
                                x = D.item
                                R = D.amount
                                b = N(x, R)
                                s = b
                                N = not s
                                flow = N and 4941688 or 7561456
                                if flow and flow >= 7526614 and flow < 7578293 then
                                    flow = 1335968
                                else
                                end
                            else
                            end
                        else
                        end
                        if flow == nil or flow < 1329230 or flow >= 1342456 then
                            break
                        end
                    end
                    if flow and flow >= 59777 and flow < 102208 then
                        flow = 7752625
                        Z = false
                        v = 'Exceeded max runtime'
                    elseif flow and flow >= 4924649 and flow < 4947404 then
                        Z = false
                        flow = 7752625
                        A = D.item
                        I = captures[11].value
                        o = D.item
                        ee = I(o)
                        p = D.amount
                        E = p .. ')'
                        I = '/' .. E
                        H = ee .. I
                        Q = ' (have ' .. H
                        R = A .. Q
                        b = 'Failed to gather enough ' .. R
                        v = b
                    else
                    end
                    C = not v
                    flow = C and 3381558 or 7066009
                    if flow and flow >= 3376623 and flow < 3382498 then
                        C = captures[8].value
                        a = C('--- All materials gathered, crafting NOW ---')
                        C = captures[12].value
                        a = C(X)
                        Z = a
                        C = not Z
                        flow = C and 7781704 or 10799283
                        if flow and flow >= 7778700 and flow < 7792729 then
                            flow = 10799283
                            v = 'CraftItem fire failed'
                        else
                        end
                        flow = 7066009
                    else
                    end
                    s = captures[6].value
                    D = s.returnToStart
                    flow = D and 16362997 or 3885867
                    J = D
                    if flow and flow >= 3868879 and flow < 3904475 then
                    else
                        flow = 3885867
                        J = y
                    end
                    flow = J and 2752882 or 1386815
                    if flow and flow >= 1342456 and flow < 1433040 then
                    else
                        J = captures[8].value
                        i = J('Returning to start position...')
                        i = env.task
                        J = i.wait
                        i = J(0.1)
                        J = captures[7].value
                        s = {
                            J(),
                        }
                        D = s[2]
                        flow = D and 8408907 or 12575876
                        if flow and flow >= 8408243 and flow < 8408954 then
                            s = y
                            D.CFrame = s
                            J = captures[8].value
                            R = env.tostring
                            Q = y.Position
                            A = {
                                R(Q),
                            }
                            s = J('Returned to start position:', unpackValues(A))
                            x = captures[6].value
                            s = x.returnSettle
                            J = s > 0
                            flow = J and 148736 or 5704175
                            if flow and flow >= 138180 and flow < 151516 then
                                flow = 5704175
                                s = env.task
                                J = s.wait
                                R = captures[6].value
                                x = R.returnSettle
                                s = J(x)
                            else
                            end
                            flow = 15865136
                        else
                            J = captures[2].value
                            flow = 15865136
                            s = J('Could not return — character lost after craft')
                        end
                        flow = 1386815
                    end
                    captures[1].value = false
                    i = captures[8].value
                    x = env.string
                    s = x.format
                    R = '########## AUTO-CRAFT END: %s (%s, %.1fs) ##########'
                    H = Z
                    A = M.name
                    flow = Z and 6100336 or 10317154
                    if flow and flow >= 6096782 and flow < 6100354 then
                        flow = 10317154
                        H = 'SUCCESS'
                    else
                    end
                    Q = H
                    flow = H and 3695521 or 9462108
                    if flow and flow >= 3675377 and flow < 3740537 then
                    else
                        flow = 3695521
                        Q = 'FAILED'
                    end
                    flow = g and 4655532 or 15746280
                    H = env.tick
                    I = H()
                    u = I - B
                    x = {
                        s(R, A, Q, u),
                    }
                    D = i(unpackValues(x))
                    if flow and flow >= 4651405 and flow < 4679513 then
                        flow = 15746280
                        i = g(Z, v)
                    else
                    end
                    flow = nil
                    results = {
                    }
                else
                    captures[1].value = false
                    i = captures[6].value
                    J = i.returnToStart
                    flow = J and 5857595 or 715694
                    C = J
                    if flow and flow >= 713145 and flow < 762329 then
                    else
                        flow = 715694
                        C = y
                    end
                    flow = C and 9863800 or 12981438
                    if flow and flow >= 9863731 and flow < 9864547 then
                        C = captures[7].value
                        i = {
                            C(),
                        }
                        J = i[2]
                        flow = J and 3167102 or 10382328
                        if flow and flow >= 3166733 and flow < 3183039 then
                            i = y
                            J.CFrame = i
                            flow = 10382328
                            C = captures[8].value
                            i = C('Returned to start position (early abort)')
                        else
                        end
                        flow = 12981438
                    else
                    end
                    flow = g and 11189060 or 11979269
                    if flow and flow >= 11178494 and flow < 11196715 then
                        flow = 11979269
                        C = g(false, 'Recipe vanished from server')
                    else
                    end
                    results = {
                    }
                    flow = nil
                end
            end
        end
        return unpackValues(results)
    end
end


functions.fn_6104603 = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local X, flow, results
        flow = 6104603
        flow = captures[1].value
        flow = flow and 3631002 or 5047112
        if flow and flow >= 3592799 and flow < 3640438 then
            flow = captures[1].value
            results = flow.Disconnect
            results = results(flow)
            captures[1].value = nil
            flow = 5047112
        else
        end
        results = captures[2].value
        flow = nil
        X = results('Fly stopped')
        results = {
        }
        return unpackValues(results)
    end
end

-- HumanoidRootPart
functions.fn_6940948 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local B, M, X, flow, g, results, v, y
        flow = 6940948
        results = captures[1].value
        flow = results.Character
        X = flow
        flow = not X
        flow = flow and 1325110 or 14196394
        if flow and flow >= 1287724 and flow < 1329230 then
            results = {
                nil,
            }
            flow = nil
        else
            flow = X.FindFirstChild
            flow = flow(X, 'HumanoidRootPart')
            g = flow
            y = not g
            flow = X.FindFirstChildOfClass
            flow = flow(X, 'Humanoid')
            results = y
            M = flow
            flow = y and 10118756 or 269597
            if flow and flow >= 269331 and flow < 269964 then
                B = not M
                flow = B and 12024563 or 16018009
                y = B
                if flow and flow >= 12013719 and flow < 12029049 then
                else
                    v = M.Health
                    flow = 12024563
                    B = v <= 0
                    y = B
                end
                flow = 10118756
                results = y
            else
            end
            flow = results and 15334685 or 2139006
            if flow and flow >= 2135661 and flow < 2139906 then
                results = {
                    X,
                    g,
                    M,
                }
                flow = nil
            else
                results = {
                    nil,
                }
                flow = nil
            end
        end
        return unpackValues(results)
    end
end


functions.notify = function(captures)
    return function(...)
        local args = { ... }
        local X, flow, results
        flow = 7200520
        X = {
            selectValues(1, unpackValues(args)),
        }
        results = captures[1].value
        flow = results.debug
        flow = flow and 2288575 or 13700742
        if flow and flow >= 2265136 and flow < 2299593 then
            flow = env.print
            results = flow('[IGRIS]', unpackValues(X))
            flow = 13700742
        else
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_7216135 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local M, X, flow, g, results
        flow = 7216135
        g = args[2]
        X = args[1]
        results = X.distance
        M = g.distance
        flow = results < M
        results = {
            flow,
        }
        flow = nil
        return unpackValues(results)
    end
end

--   Available recipe IDs:
-- AUTO-CRAFT button clicked. SelectedRecipeId:
-- Auto-Craft Started
-- No recipe selected. Check F9 for available IDs.
functions.onAutoCraft = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local B, C, D, J, M, N, R, U, V, X, Z, a, c, flow, g, i, results, v, w, x, y
        flow = 7511128
        flow = captures[1].value
        flow = flow and 3047518 or 12405387
        if flow and flow >= 3034790 and flow < 3055763 then
            flow = captures[2].value
            X = {
                ['Title'] = 'Auto-Craft',
                ['Content'] = 'Already running — wait for completion.',
                ['Duration'] = 3,
            }
            results = flow.Notify
            results = results(flow, X)
            flow = nil
            results = {
            }
        else
            flow = captures[5].value
            g = env.tostring
            y = captures[6].value
            M = {
                g(y),
            }
            results = flow('AUTO-CRAFT button clicked. SelectedRecipeId:', unpackValues(M))
            results = captures[7].value
            X = captures[6].value
            flow = results[X]
            X = {
            }
            X.value = flow
            results = X.value
            flow = not results
            flow = flow and 7691093 or 11096174
            if flow and flow >= 7646028 and flow < 7695894 then
                flow = captures[5].value
                Z = env.tostring
                v = captures[6].value
                B = Z(v)
                y = B .. '] is nil!'
                g = '  RecipesById[' .. y
                results = flow(g)
                flow = captures[5].value
                results = flow('  Available recipe IDs:')
                flow = env.pairs
                y = captures[7].value
                Z = {
                    flow(y),
                }
                g = Z[2]
                results = Z[1]
                y = results
                M = Z[3]
                flow = 13619791
                while true do
                    M, B = y(g, M)
                    flow = M and 1867942 or 12299074
                    if flow and flow >= 1848721 and flow < 1883082 then
                        flow = captures[5].value
                        Z = M
                        C = B.name
                        v = flow('    ', Z, '=', C)
                        flow = 13619791
                    else
                    end
                    if flow == nil or flow < 13608801 or flow >= 13620208 then
                        break
                    end
                end
                flow = captures[2].value
                results = {
                }
                g = flow.Notify
                M = {
                    ['Title'] = 'Auto-Craft',
                    ['Content'] = 'No recipe selected. Check F9 for available IDs.',
                    ['Duration'] = 5,
                }
                g = g(flow, M)
                flow = nil
            else
                flow = captures[5].value
                Z = X.value
                y = Z.name
                w = X.value
                v = w.id
                B = v .. ')'
                g = flow('  Recipe:', y, '(id:', B)
                g = ''
                flow = env.ipairs
                v = X.value
                B = v.requirements
                v = {
                    flow(B),
                }
                M = v[1]
                Z = v[3]
                flow = 5366927
                y = v[2]
                while true do
                    Z, v = M(y, Z)
                    flow = Z and 2562494 or 16496781
                    if flow and flow >= 2562268 and flow < 2567888 then
                        B = Z
                        flow = captures[8].value
                        U = v.item
                        w = flow(U)
                        D = B > 1
                        J = D
                        flow = D and 8412704 or 4680282
                        if flow and flow >= 4679513 and flow < 4743644 then
                        else
                            flow = 4680282
                            J = '\010'
                        end
                        C = J
                        flow = J and 13099175 or 7079293
                        if flow and flow >= 7079161 and flow < 7085502 then
                            flow = 13099175
                            C = ''
                        else
                        end
                        J = env.string
                        a = J.format
                        i = '  %s: %d/%d %s'
                        D = v.item
                        V = v.amount
                        R = v.amount
                        x = w >= R
                        N = x
                        flow = x and 5569369 or 2577947
                        if flow and flow >= 2567888 and flow < 2586211 then
                        else
                            N = 'OK'
                            flow = 2577947
                        end
                        c = N
                        flow = N and 2944353 or 4089733
                        if flow and flow >= 2921914 and flow < 2947574 then
                        else
                            flow = 2944353
                            c = 'NEED'
                        end
                        J = a(i, D, w, V, c)
                        U = C .. J
                        flow = g .. U
                        g = flow
                        flow = 5366927
                    else
                    end
                    if flow == nil or flow < 5366301 or flow >= 5368598 then
                        break
                    end
                end
                flow = nil
                M = captures[2].value
                results = {
                }
                i = X.value
                J = i.name
                i = '\010' .. g
                a = J .. i
                U = 'Target: ' .. a
                y = M.Notify
                Z = {
                    ['Title'] = 'Auto-Craft Started',
                    ['Content'] = U,
                    ['Duration'] = 5,
                }
                y = y(M, Z)
                y = env.task
                M = y.spawn
                Z = functions.fn_9319908({
                    captures[9],
                    captures[6],
                    captures[2],
                    captures[3],
                    captures[4],
                    X,
                })
                y = M(Z)
            end
        end
        return unpackValues(results)
    end
end


functions.onMonsterChams = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 7589072
        flow = captures[1].value
        X = args[1]
        g = X
        flow.monsterEnabled = g
        flow = captures[4].value
        results = flow('Monster chams:', X)
        flow = X and 3159449 or 8125116
        if flow and flow >= 3158142 and flow < 3161358 then
            flow = captures[5].value
            results = flow()
            flow = 9005671
        else
            flow = captures[6].value
            g = captures[7].value
            results = flow(g)
            flow = 9005671
        end
        flow = captures[8].value
        M = 'Title'
        y = 'Monster Chams'
        Z = 'Content'
        v = flow
        w = X
        flow = X and 3190918 or 11721395
        if flow and flow >= 3183039 and flow < 3213941 then
            flow = 11721395
            w = 'Enabled — Pathfinding Monster highlighted in red.'
        else
        end
        B = w
        flow = w and 12114112 or 13988950
        if flow and flow >= 12095105 and flow < 12117306 then
        else
            B = 'Disabled.'
            flow = 12114112
        end
        flow = v
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = flow.Notify
        results = results(flow, g)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_8596738 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 8596738
        X = args[1]
        flow = env.pairs
        y = captures[1].value
        Z = {
            flow(y),
        }
        results = Z[1]
        M = Z[3]
        flow = 13705207
        g = Z[2]
        y = results
        while true do
            M, B = y(g, M)
            flow = M and 9800920 or 15705518
            if flow and flow >= 9781738 and flow < 9807974 then
                flow = {
                }
                Z = M
                flow.value = B
                B = flow
                w = B.value
                v = w.Name
                flow = v == X
                flow = flow and 8370425 or 10745684
                if flow and flow >= 8194862 and flow < 8372386 then
                    w = functions.fn_9501983({
                        B,
                    })
                    flow = env.pcall
                    v = flow(w)
                    flow = captures[1].value
                    flow[Z] = nil
                    flow = 10745684
                else
                end
                flow = 13705207
            else
            end
            if flow == nil or flow < 13702188 or flow >= 13712565 then
                break
            end
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_8610515 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local flow, g, results
        flow = 8610515
        flow = captures[1].value
        g = flow.FindFirstChild
        results = {
            g(flow, 'Inventory'),
        }
        results = {
            unpackValues(results),
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.onLocalFillColor = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local X, flow, g, results
        flow = 8633425
        flow = captures[1].value
        X = args[1]
        g = X
        flow.localFillColor = g
        results = captures[1].value
        flow = results.localEnabled
        flow = flow and 9360655 or 6295238
        if flow and flow >= 6223800 and flow < 6323909 then
        else
            flow = captures[4].value
            results = flow()
            flow = 6295238
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end

-- Local Player Chams
-- Local player chams:
functions.onLocalPlayerChams = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 8712963
        X = args[1]
        flow = captures[1].value
        g = X
        flow.localEnabled = g
        flow = captures[4].value
        results = flow('Local player chams:', X)
        flow = X and 691238 or 13880289
        if flow and flow >= 689319 and flow < 696126 then
            flow = captures[5].value
            results = flow()
            flow = 4188978
        else
            flow = captures[6].value
            g = captures[7].value
            results = flow(g)
            flow = 4188978
        end
        flow = captures[8].value
        M = 'Title'
        y = 'Local Player Chams'
        Z = 'Content'
        v = flow
        w = X
        flow = X and 2862927 or 7408333
        if flow and flow >= 2862538 and flow < 2870683 then
            flow = 7408333
            w = 'Enabled — your character highlighted in blue.'
        else
        end
        B = w
        flow = w and 8914442 or 6872406
        if flow and flow >= 6845722 and flow < 6905566 then
            flow = 8914442
            B = 'Disabled.'
        else
        end
        flow = v
        results = flow.Notify
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = results(flow, g)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_8749031 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local X, flow, g, results
        flow = 8749031
        X = args[1]
        flow = X.CharacterAdded
        g = functions.fn_12687501({
            captures[1],
            captures[2],
            captures[3],
        })
        results = flow.Connect
        results = results(flow, g)
        flow = X.Character
        flow = flow and 3079619 or 7058890
        if flow and flow >= 3078180 and flow < 3086383 then
            flow = captures[3].value
            results = flow()
            flow = 7058890
        else
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end

-- Auto-Craft Failed
-- Auto-Craft Complete
functions.fn_9198769 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local B, C, M, U, X, Z, a, flow, g, results, v, w, y
        flow = 9198769
        X = args[1]
        flow = X and 6041344 or 233784
        g = args[2]
        if flow and flow >= 220589 and flow < 269331 then
            flow = captures[1].value
            y = 'Title'
            Z = 'Auto-Craft Failed'
            B = 'Content'
            C = g
            w = 'Reason: '
            a = flow
            flow = g and 12532858 or 15908470
            if flow and flow >= 12483206 and flow < 12537225 then
            else
                C = 'unknown'
                flow = 12532858
            end
            flow = a
            U = C .. '\010Returned to start position.'
            v = w .. U
            results = flow.Notify
            M = {
                [y] = Z,
                [B] = v,
                ['Duration'] = 8,
            }
            results = results(flow, M)
            flow = 14040527
        else
            flow = captures[1].value
            U = captures[4].value
            w = U.name
            results = flow.Notify
            v = w .. ' crafted!\010Returned to start position.'
            M = {
                ['Title'] = 'Auto-Craft Complete',
                ['Content'] = v,
                ['Duration'] = 5,
            }
            results = results(flow, M)
            flow = 14040527
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_9319908 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local X, flow, g, results
        flow = 9319908
        flow = captures[1].value
        g = functions.fn_9198769({
            captures[3],
            captures[4],
            captures[5],
            captures[6],
        })
        X = captures[2].value
        results = flow(X, g)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_9432504 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local B, C, D, J, M, U, X, Z, a, flow, g, i, results, v, w, y
        flow = 9432504
        X = captures[1].value
        results = X.monsterEnabled
        flow = not results
        flow = flow and 6430893 or 634577
        if flow and flow >= 626001 and flow < 637546 then
            flow = captures[4].value
            results = flow()
            X = results
            flow = {
            }
            g = flow
            flow = env.ipairs
            Z = {
                flow(X),
            }
            results = Z[1]
            y = Z[3]
            M = Z[2]
            flow = 2430759
            Z = results
            while true do
                y, v = Z(M, y)
                flow = y and 16336864 or 5366281
                if flow and flow >= 16331893 and flow < 16343792 then
                    g[v] = true
                    flow = captures[5].value
                    U = captures[6].value
                    a = captures[1].value
                    C = a.monsterFillColor
                    J = captures[1].value
                    a = J.monsterOutlineColor
                    i = captures[1].value
                    J = i.monsterFillTransparency
                    D = captures[1].value
                    i = D.monsterOutlineTransparency
                    w = flow(v, U, C, a, J, i)
                    flow = 2430759
                else
                end
                if flow == nil or flow < 2420232 or flow >= 2432626 then
                    break
                end
            end
            flow = env.pairs
            B = captures[7].value
            v = {
                flow(B),
            }
            flow = 11664712
            M = v[1]
            y = v[2]
            Z = v[3]
            while true do
                Z, v = M(y, Z)
                flow = Z and 4500076 or 10465609
                if flow and flow >= 4499468 and flow < 4545859 then
                    B = Z
                    C = v.Name
                    a = captures[6].value
                    U = C == a
                    flow = U and 15497809 or 12012940
                    w = U
                    if flow and flow >= 11986505 and flow < 12013719 then
                    else
                        C = g[B]
                        flow = 12012940
                        U = not C
                        w = U
                    end
                    flow = w and 3589030 or 2798544
                    if flow and flow >= 2775052 and flow < 2804042 then
                    else
                        flow = captures[8].value
                        w = flow(B)
                        flow = 2798544
                    end
                    flow = 11664712
                else
                end
                if flow == nil or flow < 11660443 or flow >= 11670200 then
                    break
                end
            end
            results = {
            }
            flow = nil
        else
            flow = nil
            results = {
            }
        end
        return unpackValues(results)
    end
end


functions.fn_9501983 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local flow, results
        flow = 9501983
        flow = captures[1].value
        results = flow.Destroy
        results = results(flow)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.onPlayerFillColor = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local X, flow, g, results
        flow = 9684607
        X = args[1]
        flow = captures[1].value
        g = X
        flow.playerFillColor = g
        results = captures[1].value
        flow = results.playerEnabled
        flow = flow and 3974937 or 6527160
        if flow and flow >= 3920305 and flow < 3980379 then
            flow = captures[4].value
            results = flow()
            flow = 6527160
        else
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.onPlayerOutlineColor = function(captures)
    return function(arg1)
        local args = { arg1 }
        local X, flow, g, results
        flow = 10049989
        flow = captures[1].value
        X = args[1]
        g = X
        flow.playerOutlineColor = g
        results = captures[1].value
        flow = results.playerEnabled
        flow = flow and 5272326 or 16279243
        if flow and flow >= 5263395 and flow < 5274313 then
            flow = captures[4].value
            results = flow()
            flow = 16279243
        else
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_10419072 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local B, C, J, M, U, X, Z, a, flow, g, i, results, v, w, y
        flow = 10419072
        flow = captures[1].value
        X = args[1]
        g = args[2]
        results = flow()
        M = results
        flow = not M
        flow = flow and 16224450 or 8845088
        if flow and flow >= 8842752 and flow < 8870293 then
            flow = {
            }
            y = flow
            flow = env.ipairs
            w = M.GetChildren
            v = {
                w(M),
            }
            w = {
                flow(unpackValues(v)),
            }
            results = w[1]
            v = results
            flow = 13294407
            B = w[3]
            Z = w[2]
            while true do
                B, U = v(Z, B)
                flow = B and 6373902 or 11030224
                if flow and flow >= 6373716 and flow < 6375297 then
                    C = U.GetAttribute
                    C = C(U, 'MaterialName')
                    flow = C == X
                    flow = flow and 13255623 or 4894006
                    if flow and flow >= 4852839 and flow < 4896309 then
                    else
                        flow = captures[4].value
                        C = flow(U)
                        flow = C and 4212408 or 8916832
                        if flow and flow >= 4204896 and flow < 4239735 then
                            a = C - g
                            flow = a.Magnitude
                            a = flow
                            J = env.table
                            flow = J.insert
                            i = {
                                ['instance'] = U,
                                ['position'] = C,
                                ['distance'] = a,
                            }
                            J = flow(y, i)
                            flow = 8916832
                        else
                        end
                        flow = 4894006
                    end
                    flow = 13294407
                else
                end
                if flow == nil or flow < 13277430 or flow >= 13297659 then
                    break
                end
            end
            Z = env.table
            results = {
                y,
            }
            flow = Z.sort
            B = functions.fn_7216135({
                captures[2],
                captures[3],
            })
            Z = flow(y, B)
            flow = nil
        else
            flow = {
            }
            results = {
                flow,
            }
            flow = nil
        end
        return unpackValues(results)
    end
end


functions.fn_10497903 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local B, C, M, U, X, Z, a, flow, g, results, v, y
        flow = 10497903
        flow = 15754795
        while true do
            flow = true and 13267623 or 8798534
            if flow and flow >= 13263656 and flow < 13277430 then
                results = env.task
                flow = results.wait
                g = captures[3].value
                X = g.refreshInterval
                results = flow(X)
                flow = env.pairs
                M = captures[4].value
                y = {
                    flow(M),
                }
                g = y[3]
                flow = 2105342
                X = y[2]
                results = y[1]
                M = results
                while true do
                    g, Z = M(X, g)
                    flow = g and 15004632 or 16326477
                    if flow and flow >= 14973521 and flow < 15006983 then
                        y = g
                        flow = {
                        }
                        flow.value = Z
                        Z = flow
                        U = not y
                        v = U
                        flow = U and 496163 or 8678561
                        if flow and flow >= 462509 and flow < 509358 then
                        else
                            C = y.Parent
                            U = not C
                            flow = 496163
                            v = U
                        end
                        flow = v and 1554183 or 7179833
                        B = v
                        if flow and flow >= 1545334 and flow < 1554515 then
                        else
                            C = Z.value
                            U = not C
                            flow = U and 11739097 or 3493156
                            v = U
                            if flow and flow >= 3476997 and flow < 3510202 then
                                a = Z.value
                                flow = 11739097
                                C = a.Parent
                                U = not C
                                v = U
                            else
                            end
                            B = v
                            flow = 1554183
                        end
                        flow = B and 6980861 or 6156723
                        if flow and flow >= 6148015 and flow < 6223800 then
                        else
                            flow = env.pcall
                            v = functions.fn_3907422({
                                Z,
                            })
                            B = flow(v)
                            flow = captures[4].value
                            flow[y] = nil
                            flow = 6156723
                        end
                        flow = 2105342
                    else
                    end
                    if flow == nil or flow < 2086574 or flow >= 2105559 then
                        break
                    end
                end
                X = captures[3].value
                flow = X.monsterEnabled
                flow = flow and 10096843 or 1542754
                if flow and flow >= 1535112 and flow < 1545334 then
                else
                    flow = captures[5].value
                    X = flow()
                    flow = 1542754
                end
                M = captures[3].value
                g = M.playerEnabled
                X = g
                flow = g and 520332 or 8162342
                if flow and flow >= 509358 and flow < 538140 then
                else
                    M = captures[3].value
                    flow = 520332
                    g = M.localEnabled
                    X = g
                end
                flow = X and 6389758 or 12202186
                if flow and flow >= 6375297 and flow < 6427819 then
                    flow = captures[6].value
                    X = flow()
                    flow = 12202186
                else
                end
                flow = 15754795
            else
            end
            if flow == nil or flow < 15750786 or flow >= 15761568 then
                break
            end
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end

-- [DIAG] Workspace.MaterialNodes has %d children with MaterialName attribute:
-- [DIAG] Workspace.MaterialNodes does NOT exist
functions.fn_10556480 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local B, C, J, M, U, X, Z, a, flow, g, i, results, v, w, y
        flow = 10556480
        flow = captures[1].value
        results = flow()
        X = results
        flow = not X
        flow = flow and 8919309 or 10552127
        if flow and flow >= 8917468 and flow < 8924142 then
            flow = captures[2].value
            results = flow('[DIAG] Workspace.MaterialNodes does NOT exist')
            flow = nil
            results = {
            }
        else
            flow = {
            }
            g = flow
            M = 0
            v = X.GetChildren
            flow = env.ipairs
            B = {
                v(X),
            }
            v = {
                flow(unpackValues(B)),
            }
            y = v[2]
            flow = 10492998
            results = v[1]
            B = results
            Z = v[3]
            while true do
                Z, w = B(y, Z)
                flow = Z and 9835416 or 2916859
                if flow and flow >= 9807974 and flow < 9836754 then
                    flow = w.GetAttribute
                    flow = flow(w, 'MaterialName')
                    U = flow
                    flow = U and 10323451 or 9446761
                    if flow and flow >= 9443191 and flow < 9447939 then
                    else
                        J = g[U]
                        C = J or 0
                        flow = C + 1
                        C = flow
                        g[U] = C
                        C = M + 1
                        M = C
                        flow = 9446761
                    end
                    flow = 10492998
                else
                end
                if flow == nil or flow < 10466026 or flow >= 10493005 then
                    break
                end
            end
            y = captures[2].value
            v = env.string
            B = v.format
            v = {
                B('[DIAG] Workspace.MaterialNodes has %d children with MaterialName attribute:', M),
            }
            Z = y(unpackValues(v))
            y = env.pairs
            flow = 11298365
            w = {
                y(g),
            }
            B = w[2]
            Z = w[1]
            v = w[3]
            while true do
                v, w = Z(B, v)
                flow = v and 4917714 or 408172
                if flow and flow >= 4913914 and flow < 4924649 then
                    U = captures[2].value
                    y = v
                    i = env.string
                    J = i.format
                    i = {
                        J('  %s: %d', y, w),
                    }
                    flow = 11298365
                    a = U(unpackValues(i))
                else
                end
                if flow == nil or flow < 11294765 or flow >= 11299727 then
                    break
                end
            end
            results = {
            }
            flow = nil
        end
        return unpackValues(results)
    end
end


functions.fn_10826964 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local M, X, flow, results
        flow = 10826964
        X = args[1]
        flow = captures[1].value
        M = X.Name
        results = flow('Player added:', M)
        flow = captures[4].value
        results = flow(X)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_11317066 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local X, flow, g, results, y
        flow = 11317066
        results = captures[1].value
        X = captures[2].value
        flow = results[X]
        X = flow
        g = X
        flow = X and 3166413 or 613565
        if flow and flow >= 585611 and flow < 617531 then
        else
            flow = 613565
            y = X.name
            g = y
        end
        results = g or nil
        results = {
            results,
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.onMonsterOutlineColor = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local X, flow, g, results
        flow = 11857367
        X = args[1]
        flow = captures[1].value
        g = X
        flow.monsterOutlineColor = g
        results = captures[1].value
        flow = results.monsterEnabled
        flow = flow and 9626917 or 11725653
        if flow and flow >= 9608178 and flow < 9650480 then
            flow = captures[4].value
            results = flow()
            flow = 11725653
        else
        end
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end

-- Loaded. Open Visuals for chams, Auto-Craft for gather+craft.
-- Chams system initialized.
--   Monster enabled:
--   Player  enabled:
functions.fn_11896162 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local M, X, flow, g, results, y
        flow = 11896162
        results = env.task
        flow = results.wait
        results = flow(1)
        flow = captures[3].value
        results = flow()
        flow = captures[4].value
        results = flow()
        flow = captures[5].value
        results = flow('Chams system initialized.')
        flow = captures[5].value
        M = captures[6].value
        g = M.monsterEnabled
        results = flow('  Monster enabled:', g)
        flow = captures[5].value
        M = captures[6].value
        g = M.playerEnabled
        results = flow('  Player  enabled:', g)
        flow = captures[5].value
        M = captures[6].value
        g = M.localEnabled
        results = flow('  Local   enabled:', g)
        flow = captures[7].value
        results = flow()
        flow = results and 7581915 or 7942264
        if flow and flow >= 7578293 and flow < 7583510 then
            flow = captures[5].value
            M = captures[8].value
            g = #M
            y = captures[9].value
            results = flow('Loaded', g, 'recipes. Default:', y)
            flow = 11118235
        else
            flow = captures[5].value
            results = flow('Failed to fetch recipes on init — use Refresh button later')
            flow = 11118235
        end
        flow = captures[10].value
        results = flow.Notify
        X = {
            ['Title'] = 'IGRIS Hub',
            ['Content'] = 'Loaded. Open Visuals for chams, Auto-Craft for gather+craft.',
            ['Duration'] = 6,
        }
        results = results(flow, X)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.onFly = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 12035922
        flow = captures[1].value
        X = args[1]
        g = X
        flow.flyEnabled = g
        flow = captures[4].value
        results = flow('Fly:', X)
        flow = X and 6107283 or 9940375
        if flow and flow >= 6105756 and flow < 6118633 then
            flow = captures[5].value
            results = flow()
            flow = 1604121
        else
            flow = captures[6].value
            results = flow()
            flow = 1604121
        end
        flow = captures[7].value
        M = 'Title'
        y = 'Fly'
        Z = 'Content'
        v = flow
        flow = X and 6010977 or 5369698
        w = X
        if flow and flow >= 5368598 and flow < 5372060 then
        else
            flow = 5369698
            w = 'Enabled — WASD to move, Space up, Shift down.'
        end
        flow = w and 16408067 or 12556199
        B = w
        if flow and flow >= 12549015 and flow < 12560842 then
            flow = 16408067
            B = 'Disabled.'
        else
        end
        flow = v
        results = flow.Notify
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = results(flow, g)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_12036851 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local flow, results
        flow = 12036851
        flow = captures[1].value
        results = flow.Destroy
        results = results(flow)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.onInfiniteHunger = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local B, M, X, Z, flow, g, results, v, w, y
        flow = 12092016
        flow = captures[1].value
        X = args[1]
        g = X
        flow.infHunger = g
        flow = captures[4].value
        results = flow('Inf hunger:', X)
        flow = captures[5].value
        M = 'Title'
        y = 'Inf Hunger'
        v = flow
        flow = X and 3588704 or 2462187
        Z = 'Content'
        w = X
        if flow and flow >= 2455626 and flow < 2477386 then
        else
            w = 'Hunger locked to 100 — never starve.'
            flow = 2462187
        end
        B = w
        flow = w and 4041323 or 5344835
        if flow and flow >= 4015142 and flow < 4052491 then
        else
            flow = 4041323
            B = 'Disabled.'
        end
        flow = v
        results = flow.Notify
        g = {
            [M] = y,
            [Z] = B,
            ['Duration'] = 3,
        }
        results = results(flow, g)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_12582954 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local B, C, M, U, X, Z, flow, g, results, v, w, y
        flow = 12582954
        flow = {
        }
        results = {
        }
        captures[1].value = flow
        captures[2].value = results
        X = env.ipairs
        v = captures[3].value
        Z = v
        flow = v and 539304 or 15731402
        if flow and flow >= 538140 and flow < 585611 then
        else
            v = {
            }
            Z = v
            flow = 539304
        end
        B = {
            X(Z),
        }
        flow = 11045028
        y = B[3]
        g = B[1]
        M = B[2]
        while true do
            y, Z = g(M, y)
            flow = y and 8039886 or 11944894
            if flow and flow >= 8019505 and flow < 8061565 then
                w = Z.requirements
                flow = w and 15518079 or 5718068
                B = w
                if flow and flow >= 5714593 and flow < 5762336 then
                else
                    C = Z.requirements
                    U = #C
                    w = U > 0
                    B = w
                    flow = 5718068
                end
                flow = B and 2844765 or 2352248
                if flow and flow >= 2348788 and flow < 2380376 then
                else
                    B = captures[1].value
                    v = Z.name
                    w = Z.id
                    B[v] = w
                    v = env.table
                    B = v.insert
                    w = captures[2].value
                    flow = 2352248
                    U = Z.name
                    v = B(w, U)
                end
                flow = 11045028
            else
            end
            if flow == nil or flow < 11042929 or flow >= 11047925 then
                break
            end
        end
        g = env.table
        results = {
        }
        flow = nil
        X = g.sort
        M = captures[2].value
        g = X(M)
        return unpackValues(results)
    end
end


functions.fn_12611079 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local B, C, D, J, M, U, X, Z, a, flow, g, i, results, v, w, y
        flow = 12611079
        M = captures[1].value
        g = M.playerEnabled
        X = not g
        flow = X and 7360449 or 2328317
        results = X
        if flow and flow >= 2299593 and flow < 2328460 then
        else
            M = captures[1].value
            g = M.localEnabled
            X = not g
            flow = 2328317
            results = X
        end
        flow = results and 8141307 or 9781350
        if flow and flow >= 8131506 and flow < 8147817 then
            flow = nil
            results = {
            }
        else
            flow = {
            }
            X = flow
            flow = env.ipairs
            y = captures[4].value
            B = y.GetPlayers
            Z = {
                B(y),
            }
            y = {
                flow(unpackValues(Z)),
            }
            results = y[1]
            M = y[3]
            g = y[2]
            y = results
            flow = 15517714
            while true do
                M, B = y(g, M)
                flow = M and 2640776 or 2453880
                if flow and flow >= 2619087 and flow < 2641514 then
                    flow = B.Character
                    v = flow
                    w = v
                    flow = v and 7123604 or 5907651
                    if flow and flow >= 5888310 and flow < 5911753 then
                    else
                        a = v.Parent
                        U = a
                        flow = a and 6741039 or 2525153
                        if flow and flow >= 2502702 and flow < 2526448 then
                        else
                            flow = 2525153
                            a = v.FindFirstChildOfClass
                            a = a(v, 'Humanoid')
                            U = a
                        end
                        w = U
                        flow = 5907651
                    end
                    flow = w and 13306339 or 1084735
                    if flow and flow >= 1042890 and flow < 1087489 then
                    else
                        w = captures[5].value
                        flow = B == w
                        flow = flow and 8721793 or 12858911
                        if flow and flow >= 8720884 and flow < 8742922 then
                            w = captures[1].value
                            flow = w.localEnabled
                            flow = flow and 3442144 or 3657065
                            if flow and flow >= 3439211 and flow < 3448751 then
                                X[v] = true
                                flow = captures[6].value
                                U = captures[7].value
                                a = captures[1].value
                                C = a.localFillColor
                                J = captures[1].value
                                a = J.localOutlineColor
                                i = captures[1].value
                                J = i.localFillTransparency
                                D = captures[1].value
                                i = D.localOutlineTransparency
                                w = flow(v, U, C, a, J, i)
                                flow = 3657065
                            else
                            end
                            flow = 7823202
                        else
                            w = captures[1].value
                            flow = w.playerEnabled
                            flow = flow and 13438415 or 11050110
                            if flow and flow >= 11047925 and flow < 11079530 then
                            else
                                X[v] = true
                                flow = captures[6].value
                                U = captures[8].value
                                a = captures[1].value
                                C = a.playerFillColor
                                J = captures[1].value
                                a = J.playerOutlineColor
                                i = captures[1].value
                                J = i.playerFillTransparency
                                D = captures[1].value
                                i = D.playerOutlineTransparency
                                w = flow(v, U, C, a, J, i)
                                flow = 11050110
                            end
                            flow = 7823202
                        end
                        flow = 1084735
                    end
                    flow = 15517714
                else
                end
                if flow == nil or flow < 15517272 or flow >= 15517777 then
                    break
                end
            end
            flow = env.pairs
            Z = captures[9].value
            B = {
                flow(Z),
            }
            flow = 11583451
            g = B[1]
            M = B[2]
            y = B[3]
            while true do
                y, B = g(M, y)
                flow = y and 16756127 or 12396371
                if flow and flow >= 16726105 and flow < 16774895 then
                    Z = y
                    a = B.Name
                    J = captures[8].value
                    C = a == J
                    w = C
                    flow = C and 5244574 or 5378301
                    if flow and flow >= 5242322 and flow < 5247950 then
                    else
                        flow = 5244574
                        a = B.Name
                        J = captures[7].value
                        C = a == J
                        w = C
                    end
                    v = w
                    flow = w and 16720608 or 10837863
                    if flow and flow >= 10828126 and flow < 10860214 then
                    else
                        flow = 10837863
                        U = X[Z]
                        w = not U
                        v = w
                    end
                    flow = v and 14733239 or 15010315
                    if flow and flow >= 14701013 and flow < 14733946 then
                        flow = captures[10].value
                        v = flow(Z)
                        flow = 15010315
                    else
                    end
                    flow = 11583451
                else
                end
                if flow == nil or flow < 11581522 or flow >= 11605431 then
                    break
                end
            end
            results = {
            }
            flow = nil
        end
        return unpackValues(results)
    end
end


functions.fn_12687501 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local flow, results
        flow = 12687501
        results = env.task
        flow = results.wait
        results = flow(0.3)
        flow = captures[3].value
        results = flow()
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end

-- Fly started (speed:
functions.fn_13029380 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local M, X, Z, flow, results, y
        flow = 13029380
        flow = captures[1].value
        flow = flow and 4761255 or 11197314
        if flow and flow >= 4743644 and flow < 4763922 then
            flow = nil
            results = {
            }
        else
            results = captures[2].value
            flow = results.Heartbeat
            X = functions.fn_4498933({
                captures[5],
                captures[3],
                captures[4],
                captures[6],
                captures[7],
                captures[8],
            })
            results = flow.Connect
            results = results(flow, X)
            captures[1].value = results
            flow = captures[9].value
            Z = captures[5].value
            results = {
            }
            y = Z.flySpeed
            M = y .. ')'
            X = flow('Fly started (speed:', M)
            flow = nil
        end
        return unpackValues(results)
    end
end

-- Logged to F9 console.
-- No Inventory folder found
-- === INVENTORY STATUS ===
functions.onShowInventory = function(captures)
    return function()
        local args = {  }
        local B, M, U, X, Z, a, flow, g, results, v, w, y
        flow = 13233654
        flow = captures[1].value
        results = flow()
        X = results
        flow = not X
        flow = flow and 10249486 or 15513344
        if flow and flow >= 10207016 and flow < 10253542 then
            flow = captures[2].value
            results = flow('No Inventory folder found')
            flow = nil
            results = {
            }
        else
            flow = captures[2].value
            results = flow('=== INVENTORY STATUS ===')
            flow = env.ipairs
            Z = X.GetChildren
            y = {
                Z(X),
            }
            Z = {
                flow(unpackValues(y)),
            }
            M = Z[3]
            flow = 7406857
            g = Z[2]
            results = Z[1]
            y = results
            while true do
                M, B = y(g, M)
                flow = M and 14266542 or 1972
                if flow and flow >= 14229042 and flow < 14274699 then
                    w = B.IsA
                    w = w(B, 'IntValue')
                    v = w
                    flow = w and 2329934 or 15936510
                    if flow and flow >= 2328460 and flow < 2348788 then
                        U = B.Value
                        flow = 15936510
                        w = U > 0
                        v = w
                    else
                    end
                    flow = v and 13183072 or 6432356
                    if flow and flow >= 6431876 and flow < 6466028 then
                    else
                        flow = env.print
                        U = B.Name
                        a = B.Value
                        v = flow('  ', U, '=', a)
                        flow = 6432356
                    end
                    flow = 7406857
                else
                end
                if flow == nil or flow < 7405830 or flow >= 7407146 then
                    break
                end
            end
            flow = captures[5].value
            results = {
            }
            g = flow.Notify
            M = {
                ['Title'] = 'Inventory',
                ['Content'] = 'Logged to F9 console.',
                ['Duration'] = 3,
            }
            g = g(flow, M)
            flow = nil
        end
        return unpackValues(results)
    end
end

-- Workspace.MaterialNodes does NOT exist. See F9.
-- [DIAG] Workspace.MaterialNodes does NOT exist!
-- [DIAG] Available workspace top-level children:
-- [DIAG] Workspace.MaterialNodes found. Class:
functions.onDiagnoseMaterialNodes = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local B, C, J, M, U, X, Z, flow, g, i, results, v, y
        flow = 13680298
        flow = captures[1].value
        results = flow('=== MATERIAL NODE DIAGNOSTIC ===')
        flow = captures[4].value
        results = flow()
        X = results
        flow = not X
        flow = flow and 4608383 or 10330277
        if flow and flow >= 4608372 and flow < 4628644 then
            flow = captures[1].value
            results = flow('[DIAG] Workspace.MaterialNodes does NOT exist!')
            flow = captures[1].value
            results = flow('[DIAG] Available workspace top-level children:')
            flow = env.ipairs
            y = captures[5].value
            B = y.GetChildren
            Z = {
                B(y),
            }
            y = {
                flow(unpackValues(Z)),
            }
            results = y[1]
            M = y[3]
            g = y[2]
            flow = 12175883
            y = results
            while true do
                M, B = y(g, M)
                flow = M and 2848105 or 2204479
                if flow and flow >= 2846846 and flow < 2862538 then
                    flow = captures[1].value
                    U = B.Name
                    i = B.ClassName
                    J = i .. ')'
                    C = '(' .. J
                    v = flow('  -', U, C)
                    flow = 12175883
                else
                end
                if flow == nil or flow < 12168569 or flow >= 12182193 then
                    break
                end
            end
            flow = captures[6].value
            g = flow.Notify
            M = {
                ['Title'] = 'Diagnose',
                ['Content'] = 'Workspace.MaterialNodes does NOT exist. See F9.',
                ['Duration'] = 5,
            }
            g = g(flow, M)
            flow = nil
            results = {
            }
        else
            flow = captures[1].value
            y = X.ClassName
            g = flow('[DIAG] Workspace.MaterialNodes found. Class:', y)
            flow = captures[1].value
            Z = X.GetChildren
            Z = Z(X)
            results = {
            }
            y = #Z
            g = flow('[DIAG] Total direct children:', y)
            flow = captures[7].value
            g = flow()
            flow = captures[6].value
            g = flow.Notify
            M = {
                ['Title'] = 'Diagnose',
                ['Content'] = 'Material nodes logged to F9 console.',
                ['Duration'] = 3,
            }
            g = g(flow, M)
            flow = nil
        end
        return unpackValues(results)
    end
end

-- Return to start:
functions.onReturnAfterCraft = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5, arg6)
        local args = { arg1, arg2, arg3, arg4, arg5, arg6 }
        local X, flow, g, results
        flow = 13721189
        flow = captures[1].value
        X = args[1]
        g = X
        flow.returnToStart = g
        flow = captures[4].value
        results = flow('Return to start:', X)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_14061792 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local M, X, flow, g, results
        flow = 14061792
        results = env.Instance
        flow = results.new
        results = flow('Highlight')
        X = results
        results = captures[3].value
        X.Name = results
        results = captures[4].value
        X.Adornee = results
        results = captures[5].value
        X.FillColor = results
        results = captures[6].value
        X.OutlineColor = results
        results = captures[7].value
        X.FillTransparency = results
        results = captures[8].value
        X.OutlineTransparency = results
        M = env.Enum
        g = M.HighlightDepthMode
        results = g.AlwaysOnTop
        X.DepthMode = results
        results = captures[9].value
        X.Parent = results
        results = {
            X,
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_14211538 = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local flow, results
        flow = 14211538
        flow = captures[1].value
        results = flow.Destroy
        results = results(flow)
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end


functions.fn_14509896 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local X, flow, results
        flow = 14509896
        results = captures[1].value
        X = captures[2].value
        flow = results[X]
        results = flow.Destroy
        results = results(flow)
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.onMonsterTransparency = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local X, flow, g, results
        flow = 14585478
        X = args[1]
        flow = captures[1].value
        g = X
        flow.monsterFillTransparency = g
        results = captures[1].value
        flow = results.monsterEnabled
        flow = flow and 11118780 or 15931962
        if flow and flow >= 11118346 and flow < 11150685 then
            flow = captures[4].value
            results = flow()
            flow = 15931962
        else
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_14663644 = function(captures)
    return function(arg1, arg2, arg3, arg4)
        local args = { arg1, arg2, arg3, arg4 }
        local X, flow, g, results
        flow = 14663644
        results = captures[1].value
        flow = results.infStamina
        flow = flow and 2898713 or 5252560
        if flow and flow >= 2870683 and flow < 2907140 then
            flow = captures[4].value
            results = flow.FindFirstChild
            results = results(flow, 'Stamina')
            X = results
            flow = X and 1772295 or 6639376
            results = X
            if flow and flow >= 1762016 and flow < 1795597 then
                flow = 6639376
                g = X.IsA
                g = g(X, 'NumberValue')
                results = g
            else
            end
            flow = results and 860215 or 5651596
            if flow and flow >= 849034 and flow < 878109 then
                X.Value = 420
                flow = 5651596
            else
            end
            flow = 5252560
        else
        end
        results = captures[1].value
        flow = results.infHunger
        flow = flow and 14060504 or 2438035
        if flow and flow >= 2432626 and flow < 2442126 then
        else
            flow = captures[4].value
            results = flow.FindFirstChild
            results = results(flow, 'Hunger')
            X = results
            flow = X and 6564390 or 2586772
            results = X
            if flow and flow >= 2586211 and flow < 2608799 then
            else
                g = X.IsA
                flow = 2586772
                g = g(X, 'NumberValue')
                results = g
            end
            flow = results and 104327 or 3383623
            if flow and flow >= 102208 and flow < 115362 then
                X.Value = 100
                flow = 3383623
            else
            end
            flow = 2438035
        end
        results = captures[1].value
        flow = results.infThirst
        flow = flow and 7079145 or 12048881
        if flow and flow >= 7075874 and flow < 7079161 then
            flow = captures[4].value
            results = flow.FindFirstChild
            results = results(flow, 'Thirst')
            X = results
            flow = X and 15850608 or 16704413
            results = X
            if flow and flow >= 15839658 and flow < 15854916 then
                g = X.IsA
                g = g(X, 'NumberValue')
                flow = 16704413
                results = g
            else
            end
            flow = results and 1555991 or 8375750
            if flow and flow >= 1554637 and flow < 1580272 then
                X.Value = 100
                flow = 8375750
            else
            end
            flow = 12048881
        else
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_14754215 = function(captures)
    return function(arg1)
        local args = { arg1 }
        local X, flow, g, results
        flow = 14754215
        X = args[1]
        results = X.Name
        g = captures[3].value
        flow = results == g
        flow = flow and 9102292 or 1740700
        if flow and flow >= 1729743 and flow < 1762016 then
        else
            flow = captures[4].value
            results = flow('Monster spawned — waiting for full load')
            results = env.task
            flow = results.wait
            results = flow(0.2)
            flow = captures[5].value
            results = flow()
            flow = 1740700
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end

-- Monster removed
functions.fn_14826472 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5)
        local args = { arg1, arg2, arg3, arg4, arg5 }
        local X, flow, g, results
        flow = 14826472
        X = args[1]
        results = X.Name
        g = captures[3].value
        flow = results == g
        flow = flow and 11744099 or 16692328
        if flow and flow >= 11741205 and flow < 11759300 then
            flow = captures[4].value
            results = flow('Monster removed')
            flow = captures[5].value
            results = flow(X)
            flow = 16692328
        else
        end
        flow = nil
        results = {
        }
        return unpackValues(results)
    end
end


functions.fn_15146232 = function(captures)
    return function(arg1, arg2, arg3)
        local args = { arg1, arg2, arg3 }
        local M, X, flow, g, results, y
        flow = 15146232
        X = args[1]
        g = args[2]
        flow = g and 10254424 or 4770197
        if flow and flow >= 4766384 and flow < 4770609 then
            results = X.KeyCode
            flow = results.Name
            y = captures[3].value
            M = flow
            results = y[M]
            flow = results ~= nil
            flow = flow and 8985035 or 6679665
            if flow and flow >= 6674900 and flow < 6685601 then
            else
                flow = captures[3].value
                flow[M] = true
                flow = 6679665
            end
            flow = nil
            results = {
            }
        else
            flow = nil
            results = {
            }
        end
        return unpackValues(results)
    end
end


functions.fn_16646812 = function(captures)
    return function(arg1, arg2)
        local args = { arg1, arg2 }
        local flow, results
        flow = 16646812
        flow = captures[1].value
        results = flow()
        results = {
        }
        flow = nil
        return unpackValues(results)
    end
end

-- Unknown recipe id:
-- CraftItem fired for:
-- CraftItem FireServer error:
-- === CRAFT %s (firing immediately, no craftTime wait) ===
functions.fn_16775358 = function(captures)
    return function(arg1, arg2, arg3, arg4, arg5, arg6)
        local args = { arg1, arg2, arg3, arg4, arg5, arg6 }
        local B, M, X, Z, flow, g, results, v, y
        flow = 16775358
        X = {
        }
        X.value = args[1]
        results = captures[1].value
        g = X.value
        flow = results[g]
        g = flow
        flow = not g
        flow = flow and 11766371 or 7466352
        if flow and flow >= 7454491 and flow < 7474940 then
            flow = captures[5].value
            y = env.string
            M = y.format
            B = g.name
            y = {
                M('=== CRAFT %s (firing immediately, no craftTime wait) ===', B),
            }
            results = flow(unpackValues(y))
            y = functions.fn_5522947({
                captures[6],
                X,
            })
            flow = env.pcall
            Z = {
                flow(y),
            }
            M = Z[2]
            results = Z[1]
            y = results
            flow = not y
            flow = flow and 45696 or 5934366
            if flow and flow >= 45484 and flow < 59777 then
                flow = captures[2].value
                B = env.tostring
                v = {
                    B(M),
                }
                results = flow('CraftItem FireServer error:', unpackValues(v))
                results = {
                    false,
                }
                flow = nil
            else
                flow = captures[5].value
                B = X.value
                results = flow('CraftItem fired for:', B)
                results = {
                    true,
                }
                flow = nil
            end
        else
            flow = captures[2].value
            y = X.value
            results = flow('Unknown recipe id:', y)
            results = {
                false,
            }
            flow = nil
        end
        return unpackValues(results)
    end
end

return functions.main({})(...)
