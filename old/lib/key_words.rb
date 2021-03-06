# coding: utf-8
module Robot
 class Key
   def initialize
    @key_positions=['start=0',
            'start=10',
            'start=20',
            'start=30',
            'start=40',
            'start=50',
            'start=60',
            'start=70',
            'start=80',
            'start=90',
            'start=100',
            'start=110',
            'start=120',
            'start=130',
            'start=140',
            'start=150',
            'start=160',
            'start=170',
            'start=180',
            'start=190']

    @key_domains=[
              '.ru',
              '.ua',
              '.com',
              '.net',
              '.org',
              #'.by',
              '.biz'
              #'.edu',
              #'.coop',
              #'.gov',
              #'.info',
              #'.int',
              #'.jobs',
              #'.mobi',
              #'.pro',
              #'.tel',
              #'.travel'
              ]




    @key_words=[
           "авторская",
           "агентство",
           "академия",
           "ассоциация",
           "бюро",
           "выбор",
           "высшая",
           "групп",
           "делового",
           "дизайна",
           "институт",
           "кадров",
           "капитал",
           "квалификации",
           "класс",
           "клуб",
           "коммуникаций",
           "компани",
           "консалт",
           "корпора",
           "коучинга",
           "курсы",
           "лаборатория",
           "лидерства",
           "личности",
           "маркетинга",
           "мастер",
           "международн",
           "менеджмент",
           "нлп",
           "новые",
           "ноу",
           "образов",
           "обучения",
           "ооо",
           "открытый",
           "партнер",
           "первый",
           "персонал",
           "повышения",
           "подготовки",
           "практик",
           "практической",
           "представительство",
           "при",
           "принцип",
           "продаж",
           "проект",
           "профессионального",
           "психологии",
           "психологическ",
           "развит",
           "ресурс",
           "решени",
           "роста",
           "семинары",
           "современных",
           "спб",
           "студия",
           "сфера",
           "технологи",
           "тренинг",
           "университет",
           "управления",
           "уральский",
           "учебный",
           "фирма",
           "центр",
           "школа",
           "экономики",
           "эксперт",
           "эффективного"]



    @key_search=[
               #"москва",
               #"санкт+петербург",
               #"екатеринбург",
               #"новосибирск",

               #"нижний+новгород",
               #"казань",
               #"самара",
               #"омск",
               #"челябинск",
               #"ростов+на+дону",
               #"уфа",
               #"волгоград",
               #"красноярск",
               #"пермь",
               #"воронеж",
               #"саратов",
               #"краснодар",
               #"тольятти",
               #"тюмень",
               #"ижевск",
              # "барнаул",
               #"ульяновск",
               #"иркутск",
               #"владивосток",
               #"ярославль",
               #"хабаровск",
               #"махачкала",
               #"оренбург",
               #"новокузнецк",
               #"томск",
               #"кемерово",
               #"рязань",
               #"астрахань",
               #"пенза",
               #"набережные+челны",
               #"липецк",
               #"тула",
               #"киров",
               #"чебоксары",
               #"калининград",
               #"курск",
               #"улан+удэ",
               #"ставрополь",
               #"магнитогорск",
               #"брянск",
               #"иваново",
               #"тверь",
               #"белгород",
               #"сочи",
               #"нижний+тагил",
               #"архангельск",
               #"владимир",
               #"калуга",
               #"чита",
               #"смоленск",
               #"волжский",
               #"курган",
               #"сургут",
               #"орёл",
               #"череповец",
               #"владикавказ",
               #"вологда",
               #"мурманск",
               #"саранск",
               #"якутск",
               #"тамбов",
               #"грозный",
               #"стерлитамак",
               #"кострома",
               #"петрозаводск",
               #"нижневартовск",
               #"комсомольск+на+амуре",
               #"йошкар+ола",
               #"таганрог",
               #"новороссийск",
               #"братск",
               #"сыктывкар",
               #"нальчик",
               #"дзержинск",
               #"шахты",
               #"орск",
               #"нижнекамск",
               #"балашиха",
               #"ангарск",
               #"химки",
               #"старый+оскол",
               #"великий+новгород",
               #"благовещенск",
               #"энгельс",
               #"подольск",
               #"псков",
               #"бийск",
               #"прокопьевск",
               #"рыбинск",
               #"балаково",
               #"армавир",
               #"южно+сахалинск",
               #"северодвинск",
               #"королёв",
               #"петропавловск+камчатский",
               #"люберцы",
               #"мытищи",
               #"норильск",
               #"сызрань",
               #"новочеркасск",
               #"златоуст",
               #"каменск+уральский",
               #"волгодонск",
               #"абакан",
               #"находка",
               #"уссурийск",
               #"электросталь",
               #"салават",
               #"березники",
               #"миасс",
               #"альметьевск",
               #"рубцовск",
               #"пятигорск",
               #"коломна",
               #"майкоп",
               #"ковров",
               #"железнодорожный",
               #"копейск",
               #"одинцово",
               #"хасавюрт",
               #"кисловодск",
               #"новомосковск",
               #"красногорск",
               #"серпухов",
               #"черкесск",
               #"нефтеюганск",
               #"первоуральск",
               #"новочебоксарск",
               #"нефтекамск",
               #"орехово+зуево",
               #"димитровград",
               #"дербент",
               #"невинномысск",
               #"камышин",
               #"новый+уренгой",
               #"батайск",
               #"кызыл",
               #"щёлково",
               #"муром",
               #"октябрьский",
               #"новошахтинск",
               #"северск",
               #"ачинск",
               #"сергиев+посад",
               #"ноябрьск",
               #"елец",
               #"новокуйбышевск",
               #"жуковский",
               #"обнинск",
               #"арзамас",
               #"пушкино",
               #"домодедово",
               #"элиста",
               #"каспийск",
               #"назрань",
               #"артём",
               #"ессентуки",
               #"ногинск",
               #"раменское",
               #"бердск",
               #"сарапул",
               #"винница",
               #"днепропетровск",
               #"донецк",
               #"житомир",
               #"запорожье",
               #"ивано+франковск",
               #"киев",
               #"кировоград",
               #"луганск",
               #"луцк",
               #"львов",
               #"николаев",
               #"одесса",
               #"полтава",
               #"ровно",
               #"симферополь",
               #"сумы",
               #"тернополь",
               #"ужгород",
               #"харьков",
               #"херсон",
               #"хмельницкий",
               #"черкассы",
               #"чернигов",
               #"черновцы",
               #"бобруйск",
               #"борисов",
               #"витебск",
               #"гомель",
               #"минск",
               #"могилёв",
               #"мозырь",
               #"орша",
               #"полоцк",
               #"речица",
               #"слуцк",
               #"быхов",
               #"ветка",
               #"горки",
               #"городок",
               #"дзержинск",
               #"добруш",
               #"дрисса",
               #"центр",
               #"школа",
               #"бизнес",
               #"компания",
               #"институт",
               #"развития",
               #"академия",
               #"консалтинговая",
               #"консалтинг",
               #"агентство",
               "бизнеса",
               "тренинг",
               "группа",
               "ооо",
               "consulting",
               "тренинговый",
               "group",
               "технологий",
               "учебный",
               "business",
               "чп",
               "студия",
               "психологии",
               "training",
               "образования",
               "тренинговая",
               "клуб",
               "мастерская",
               "обучения",
               "международный",
               "управления",
               "консалтинговый",
               "менеджмента",
               "продаж",
               "проект",
               "международная",
               "консалтинга",
               "групп",
               "психологический",
               "нлп",
               "высшая",
               "образовательный",
               "персонал",
               "ассоциация",
               "мастер",
               "тренинга",
               #"санкт",
               "бюро",
               "ноу",
               "технологии",
               "успеха",
               "университет",
               "компаний",
               "профессионального",
               "учебно",
               "коучинга",
               "развитие",
               "роста",
               "жизни",
               "консалт",
               "персонала",
               "school",
               "консультационный",
               "практической",
               "тренинги",
               "личности",
               "решений",
               "эксперт",
               "international",
               "московская",
               "consult",
               "делового",
               "маркетинга",
               "мир",
               "консалтинговое",
               "корпорация",
               "лаборатория",
               "московский",
               "партнеры",
               "плюс",
               "арт",
               "кадровое",
               "консультирования",
               "мастерства",
               "экономики",
               "дом",
               "кадровый",
               "киев",
               "тренингов",
               "факультет",
               "ukraine",
               "повышения",
               "спб",
               "тренеров",
               "квалификации",
               "петербургский",
               "решения",
               "филиал",
               "education",
               "human",
               "вектор",
               "имидж",
               "сервис",
               "актив",
               "класс",
               "корпоративного",
               "менеджмент",
               "подготовки",
               "тоо",
               "успех",
               "academy",
               "company",
               "management",
               "капитал",
               "коммуникаций",
               "профи",
               "center",
               "moscow",
               "дизайна",
               "кадровых",
               "коучинг",
               "нп",
               "поддержки",
               "ресурс",
               "человека",
               "эффективного",
               "development",
               "агенство",
               "аудит",
               "интернет",
               "карьера",
               "менеджеров",
               "научно",
               "психологическая",
               "art",
               "people",
               "service",
               "studio",
               "trainings",
               "зао",
               "кадров",
               "консультантов",
               "медиа",
               "новые",
               "новый",
               "партнер",
               "перспектива",
               "практик",
               "представительство",
               "рост",
               "современных",
               "фирма",
               "agency",
               "professional",
               "team",
               "александра",
               "альянс",
               "выбор",
               "деловой",
               "интеллект",
               "киевский",
               "корпоративных",
               "лига",
               "лидер",
               "образование",
               "открытый",
               "первый",
               "петербург",
               "президенте",
               "психологического",
               "семинары",
               "территория",
               "университета",
               "формула",
               "expert",
               "russia",
               "solutions",
               "альфа",
               "груп",
               "дополнительного",
               "дпо",
               "екатеринбург",
               "елены",
               "ларисы",
               "международное",
               "обучение",
               "первая",
               "система",
               "системы",
               "сфера",
               "театр",
               "топ",
               "тренинговое",
               "украинский",
               "управление",
               "энд",
               "event",
               "house",
               "ltd.",
               "smart",
               "авторская",
               "век",
               "гипноза",
               "государственный",
               "диалог",
               "дистанционного",
               "института",
               "ип",
               "ирины",
               "кадрового",
               "личностного",
               "международного",
               #"москва",
               "новая",
               "онлайн",
               "профессионал",
               "психология",
               "психотерапии",
               "путь",
               "ранхигс",
               "сервиса",
               "стратегия",
               "украина",
               "украинская",
               "уральский",
               "фонд",
               "цветовой",
               "best",
               "city",
               "english",
               "golden",
               "ltd",
               "personnel",
               "project",
               "английского",
               "аудиторско",
               "восток",
               "гармония",
               "город",
               "деловых",
               "знаний",
               "инновационных",
               "искусство",
               "качества",
               "компетенций",
               "курсы",
               "лидерства",
               "маркетинг",
               "методический",
               "недвижимости",
               "отношений",
               "петербургская",
               "предпринимательства",
               "психологических",
               "решение",
               "российский",
               "российской",
               "рынка",
               "северо",
               "системного",
               "управленческого",
               "юридическая",
               "alliance",
               "club",
               "coaching",
               "global",
               "life",
               "personal",
               "systems",
               "technologies",
               "анализа",
               "афина",
               "безопасности",
               "время",
               "дизайн",
               "европейский",
               "имиджа",
               "инсайт",
               "исследований",
               "команда",
               "консультант",
               "консультационная",
               "консультационно",
               "кросс",
               "людей",
               "мэйнстрим",
               "навигатор",
               "национальная",
               "организационного",
               "организация",
               "переподготовки",
               "помощи",
               "прикладной",
               "про",
               "программ",
               "профессиональная",
               "профессиональные",
               "профессиональных",
               "профит",
               "риторики",
               "русская",
               "систем",
               "сити",
               "тренер",
               "успешных",
               "фактор",
               "финансово",
               "экономическая",
               "юридический",
               "языка",
               "capital",
               "digital",
               "factors",
               "first",
               "hock",
               "level",
               "ooo",
               "pm",
               "profit",
               "retail",
               "staff",
               "авторский",
               "академии",
               "ваш",
               "вершина",
               "вкус",
               "вшэ",
               "гильдия",
               "женский",
               "знание",
               "информационный",
               "информационных",
               "исследовательский",
               "казань",
               "классического",
               "компании",
               "ланит",
               "лидеров",
               "личного",
               "натальи",
               "научный",
               "национальный",
               "новгород",
               "оао",
               "образ",
               "ораторского",
               "отделение",
               "пермь",
               "персона",
               "портал",
               "потенциал",
               "права",
               "прогресс",
               "проектов",
               "профессиональной",
               "региональное",
               "сетевая",
               "слова",
               "снг",
               "современного",
               "социальных",
               "терапии",
               "технология",
               "тренинг.",
               "тренингово",
               "триумф",
               "туризма",
               "управленческих",
               "финансовый",
               "форум",
               "челябинск",
               "эрнст",
               "эффективных",
               "языков",
               "янг",
               "centre",
               "events",
               "marketing",
               "master",
               "skills",
               "администрирования",
               "андрей",
               "архитектура",
               "взаимоотношений",
               "гештальт",
               "голоса",
               "государственного",
               "государственной",
               "движение",
               "дела",
               "дело",
               "днепропетровск",
               "запад",
               "империя",
               "инновация",
               "иностранных",
               "инталев",
               "исследовательского",
               "карьеры",
               "кафедра",
               "консалтинг.",
               "корпоративный",
               "краснодар",
               "культуры",
               "люди",
               "мегаполис",
               "межрегиональный",
               "михаила",
               "москвы",
               "нижний",
               "николаевич,",
               "ниу",
               "образовательно",
               "офис",
               "планета",
               "право",
               "правовой",
               "практика",
               "профессиональный",
               "психологической",
               "психотехнологий",
               "региональный",
               "рекламное",
               "рекламы",
               "руководителей",
               "сибирский",
               "сила",
               "службы",
               "совет",
               "сопровождения",
               "софт",
               "специалистов",
               "стратегии",
               "счастья",
               "творчества",
               "умц",
               "уровень",
               "финанс",
               "финансового",
               "холдинг",
               "экономика",
               "экономического",
               "brand",
               "businessforward",
               "group,",
               "innovation",
               "institute",
               "new",
               "nlp",
               "online",
               "partners",
               "pro",
               "recovery",
               "strategic",
               "success",
               "up",
               "активного",
               "алматы",
               "аудита",
               "байкальский",
               "бит",
               "будущего",
               "владимир",
               "возможностей",
               "воронежский",
               "дальневосточный",
               "директоров",
               "дмитрий",
               "дону",
               "женского",
               "женщин",
               "жить",
               "журналистики",
               "игоря",
               "индустрия",
               "инноваций",
               "информационно",
               "искусства",
               "калининград",
               "качество",
               "линия",
               "линк",
               "логос",
               "магазин",
               "мирбис",
               "моделирования",
               "мост",
               "навыков",
               "национального",
               "независимых",
               "новой",
               "новых",
               "образовательных",
               "общество",
               "объединение",
               "ольги",
               "открытая",
               "оценки",
               "павла",
               "первой",
               "перформия",
               "петербурге",
               "позитивной",
               "предприятий",
               "премиум",
               "пресс",
               "проблем",
               "просто",
               "профессионалов",
               "развитию",
               "ракова",
               "ресурсов",
               "ресурсы",
               "россии",
               "российская",
               "ростов",
               "стиль",
               "стимул",
               "стратегий",
               "татьяны",
               "творческая",
               "тольятти",
               "торговля",
               "трансерфинга",
               "тренинговых",
               "уральская",
               "финансов",
               "школы",
               "эволюция",
               "эра",
               "эффективности"]
   end
   attr_reader :key_positions,:key_domains,:key_words,:key_search
 end
end


