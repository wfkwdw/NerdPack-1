local n_name, NeP = ...

NeP.Locale.enUS = {
  Any = {
    NeP_Show = 'To Display '..n_name..' Execute: \n/nep show',
    ON = 'ON',
    OFF = 'OFF'
  },
  mainframe = {
    MasterToggle = 'LeftClick: Enable/Disable\nRight Click: Open Settings',
    Interrupts = 'Toggle Interrupts ON or OFF',
    Cooldowns = 'Toggle Cooldowns ON or OFF',
    AoE = 'Toggle AoE ON or OFF',
    Settings = 'Settings',
    HideNeP = 'Hide '..n_name,
    ChangeCR = 'Changed Combat Routine To:',
    Donate = 'Donate To '..n_name,
    Forum = 'Visit our forum',
    CRS = 'Combat Routines',
    CRS_ST = 'Combat Routines Settings'
  },
  OM = {
    Option = 'Units List',
    Friendly = 'Friendly\'s',
    Enemy = 'Enemies',
    Dead = 'Dead'
  },
  AL = {
    Option = 'Action Log',
    Action = 'Action',
    Description = 'Description',
    Time = 'Time'
  },
  Dummies = {
    Name = 'dummy', -- Moust common name
    Pattern = {'dummy', 'training bag'} -- These are the usual things to look for in the description in case name fails
  },
  Settings = {
    option = 'Settings',
    bsize = 'Button size',
    bpad = 'Button padding',
    brow = 'Maximum buttons per row',
    apply_bt = 'Apply',
    outline_color = 'Outline color',
    tittle_color = 'Title Color',
    tittle_alpha = 'Title Alpha',
    content_color = 'Content Color',
    content_alpha = 'Content Alpha',
    OM_Dis = "Max Distance",
    OM_Dis_desc = "This limits the maximum distance of the units/objects that can be added to the OM\n|cfffd1c15Affects performance!|r",
    UI_Settings = "User Interface Settings",
    OM_Settings = "Object Manager Settings",
    misc = 'Extras'
  },
  States = {
    charm        = {'^charmed'},
    disarm       = {'disarmed'},
    disorient    = {'^disoriented'},
    dot          = {'damage every.*sec', 'damage per.*sec'},
    fear         = {'^horrified', '^fleeing', '^feared', '^intimidated', '^cowering in fear', '^running in fear', '^compelled to flee'},
    incapacitate = {'^incapacitated', '^sapped'},
    misc         = {'unable to act', '^bound', '^frozen.$', '^cannot attack or cast spells', '^shackled.$'},
    root         = {'^rooted', '^immobil', '^webbed', 'frozen in place', '^paralyzed', '^locked in place', '^pinned in place'},
    stun         = {'^stunned', '^webbed'},
    silence      = {'^silenced'},
    sleep        = {'^asleep'},
    snare        = {'^movement.*slowed', 'movement speed reduced', '^slowed by', '^dazed', '^reduces movement speed', 'snared'}
  },
  Immune = {
    all          = {'dematerialize', 'deterrence', 'divine shield', 'ice block'},
    charm        = {'bladestorm', 'desecrated ground', 'grounding totem effect', 'lichborne'},
    disorient    = {'bladestorm', 'desecrated ground'},
    fear         = {'berserker rage', 'bladestorm', 'desecrated ground', 'grounding totem','lichborne', 'nimble brew'},
    incapacitate = {'bladestorm', 'desecrated ground'},
    melee        = {'dispersion', 'evasion', 'hand of protection', 'ring of peace', 'touch of karma'},
    misc         = {'bladestorm', 'desecrated ground'},
    silence      = {'devotion aura', 'inner focus', 'unending resolve'},
    polly        = {'immune to polymorph'},
    sleep        = {'bladestorm', 'desecrated ground', 'lichborne'},
    snare        = {'bestial wrath', 'bladestorm', 'death\'s advance', 'desecrated ground','dispersion', 'hand of freedom', 'master\'s call', 'windwalk totem'},
    spell        = {'anti-magic shell', 'cloak of shadows', 'diffuse magic', 'dispersion','massspell reflection', 'ring of peace', 'spell reflection', 'touch of karma'},
    stun         = {'bestial wrath', 'bladestorm', 'desecrated ground', 'icebound fortitude','grounding totem', 'nimble brew'}
  }
}
