Config = {}

Config.target = 'qb' -- qb or ox only.
Config.menu = 'qb' -- qb or ox only.

Config.Ped = {
    -- Configure Ped
    coords = vector4(2340.36, 3126.60, 48.21, 346.39),
    model = "a_m_m_eastsa_01",
    targetLabel = 'Open Blueprint Menu', -- Target Label
    useEmote = true, -- if this is true then the following animation will be played.
    animDict = 'anim@amb@board_room@diagram_blueprints@',
    animName = 'idle_01_amy_skater_01',
    useScenario = false, -- Must enable either emote or scenario not both.
    scenario = "WORLD_HUMAN_DRINKING",
}

Config.Rewards = {
    -- Example Rewards
    [1] = {
        blueprint = 'lockpick', -- Blueprint name goes here
        label = 'Lockpick Blueprint', -- Label used in the menu
        description = 'Get Lockpick blueprint at 2000 EXP', -- Description used in the menu
        skillRequired = 2000, -- Skills required !!!(REQUIRES CW-REP)!!!
        skillName = 'scrap' -- Skill Name !!!(REQUIRES CW-REP)!!!
        },
    [2] = {
        blueprint = 'screwdriver',
        label = 'Screwdriver Blueprint',
        description = 'Get Screwdriver blueprint at 3000 EXP',
        skillRequired = 3000,
        skillName = 'scrap'

    },
    [3] = {
        blueprint = 'blowtorch',
        label = 'Blow Torch Blueprint',
        description = 'Get Blow torch blueprint at 5000 EXP',
        skillRequired = 5000,
        skillName = 'scrap'

    }
}
