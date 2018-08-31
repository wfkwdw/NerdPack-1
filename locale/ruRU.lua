local n_name, NeP = ...

NeP.Locale.ruRU = {
  Any = {
    NeP_Show = 'Для отображения '..n_name..' используйте команду чата: \n/nep show',
    ON = 'Вкл',
    OFF = 'Выкл'
  },
  mainframe = {
    MasterToggle = 'Левый Клик: Вкл/Выкл\nПравый клик: Открыть настройки',
    Interrupts = 'Вкл/Выкл Прерывание кастов',
    Cooldowns = 'Вкл/Выкл использование КД(бурстов)',
    AoE = 'Вкл/Выкл АОЕ',
    Settings = 'Настройки',
    HideNeP = 'Скрыть '..n_name,
    ChangeCR = 'Сменить ротацию:',
    Donate = 'Сделать пожертвование '..n_name,
    Forum = 'Посетить наш форум',
    CRS = 'Ротации',
    CRS_ST = 'Настройки ротаций'
  },
  OM = {
    Option = 'Список целей',
    Friendly = 'Дружелюбны',
    Enemy = 'Враждебны',
    Dead = 'Мертвы'
  },
  AL = {
    Option = 'Лог действий',
    Action = 'Действие',
    Description = 'Описание',
    Time = 'Время'
  },
  Dummies = {
    Name = 'dummy', -- Moust commun name
    Pattern = {'dummy', 'training bag'} -- These are the usual things to look for in the description in case name fails
  },
  Settings = {
    option = 'Настройки',
    bsize = 'Размер кнопок',
    bpad = 'Отступы кнопок',
    brow = 'Максимально кнопок в ряду',
    apply_bt = 'Применить',
    outline_color = 'Внешний цвет',
    tittle_color = 'Цвет заголовка',
    tittle_alpha = 'Прозрачнось заголовка',
    content_color = 'Цвет содержания',
    content_alpha = 'Прозрачность содержания'
  },
  States = {
    charm        = {'^charmed'},
    disarm       = {'disarmed'},
    disorient    = {'^disoriented'},
    dot          = {'урона каждую.*сек', 'урона в.*сек'},
    fear         = {'^horrified', '^fleeing', '^feared', '^intimidated', '^cowering in fear', '^running in fear', '^compelled to flee'},
    incapacitate = {'^incapacitated', '^sapped'},
    misc         = {'unable to act', '^bound', '^frozen.$', '^не могу атаковать или произносить заклинания', '^shackled.$'},
    root         = {'^rooted', '^immobil', '^webbed', 'frozen in place', '^paralyzed', '^locked in place', '^pinned in place'},
    stun         = {'^stunned', '^webbed'},
    silence      = {'^silenced'},
    sleep        = {'^asleep'},
    snare        = {'^movement.*slowed', 'скорость передвижения снижена', '^slowed by', '^dazed', '^reduces movement speed'}
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
