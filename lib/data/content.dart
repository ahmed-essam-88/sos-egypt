// Static, offline emergency content. Every number here comes from Egyptian
// government pages (see sources). Nothing is invented: when a number could not
// be confirmed on an official page it is not listed.

class Svc {
  final String id, nameAr, nameEn, number, descAr, descEn;
  final bool critical;
  const Svc(this.id, this.nameAr, this.nameEn, this.number, this.descAr,
      this.descEn,
      {this.critical = false});
}

const services = <Svc>[
  Svc('ambulance', 'الإسعاف', 'Ambulance', '123',
      'حالات طبية طارئة: فقدان وعي، صعوبة تنفس، ألم صدر، نزيف شديد.',
      'Medical emergencies: unconscious person, trouble breathing, chest pain, heavy bleeding.',
      critical: true),
  Svc('police', 'النجدة (الشرطة)', 'Police emergency', '122',
      'تهديد، اعتداء، سرقة، أي خطر أمني عاجل.',
      'Threats, assault, theft, any urgent security danger.',
      critical: true),
  Svc('fire', 'المطافئ (الحماية المدنية)', 'Fire & Civil Protection', '180',
      'حرائق، انهيارات، إنقاذ محتجزين.',
      'Fires, collapses, rescue of trapped people.',
      critical: true),
  Svc('tourist', 'شرطة السياحة', 'Tourist police', '126',
      'مساعدة السائحين والزوار.', 'Help for tourists and visitors.'),
  Svc('traffic', 'شرطة المرور', 'Traffic police', '128',
      'حوادث الطرق والمرور.', 'Road and traffic incidents.'),
  Svc('gas', 'طوارئ الغاز الطبيعي', 'Natural gas emergency', '129',
      'تسريب غاز طبيعي. ابتعد عن المكان قبل الاتصال.',
      'Natural gas leak. Move away from the place before calling.'),
  Svc('child', 'نجدة الطفل', 'Child helpline', '16000',
      'طفل في خطر أو يتعرض للإيذاء.', 'A child in danger or being harmed.'),
];

const numbersSources = <String>[
  'https://kfs.gov.eg/directory',
  'https://www.giza.gov.eg/Services/Emergency%20services.aspx',
  'https://cpa.gov.eg/ar-eg/%D8%A3%D8%B1%D9%82%D8%A7%D9%85-%D8%AA%D9%87%D9%85%D9%83',
];

class Category {
  final String id, icon, titleAr, titleEn, whatAr, whatEn;
  final List<String> stepsAr, stepsEn, careAr, careEn, whenAr, whenEn, call;
  final List<String> keysAr, keysEn;
  const Category({
    required this.id,
    required this.icon,
    required this.titleAr,
    required this.titleEn,
    required this.whatAr,
    required this.whatEn,
    required this.stepsAr,
    required this.stepsEn,
    required this.careAr,
    required this.careEn,
    required this.whenAr,
    required this.whenEn,
    required this.call,
    required this.keysAr,
    required this.keysEn,
  });
}

const categories = <Category>[
  Category(
    id: 'medical',
    icon: 'medical',
    titleAr: 'طوارئ طبية',
    titleEn: 'Medical emergencies',
    whatAr: 'مرض أو إصابة مفاجئة تهدد الحياة أو تحتاج رعاية عاجلة.',
    whatEn: 'A sudden illness or injury that threatens life or needs urgent care.',
    stepsAr: [
      'اتصل بالإسعاف 123 فوراً إذا كان المصاب فاقد الوعي أو لا يتنفس طبيعياً أو يعاني من ألم صدر أو نزيف شديد.',
      'ابقَ مع المصاب ولا تحركه إلا إذا كان المكان نفسه خطراً.',
      'لنزيف: اضغط مباشرة وبقوة على الجرح بقطعة قماش نظيفة ولا ترفعها.',
      'إذا كان لا يتنفس ولا يستجيب: ابدأ ضغطات الصدر في منتصف الصدر بسرعة وقوة (حوالي 100 إلى 120 ضغطة في الدقيقة) حتى يصل الإسعاف.',
      'اتبع تعليمات مشغل الإسعاف على الهاتف.',
    ],
    stepsEn: [
      'Call the ambulance (123) immediately if the person is unconscious, not breathing normally, has chest pain, or is bleeding heavily.',
      'Stay with the person. Do not move them unless the place itself is dangerous.',
      'For bleeding: press firmly and directly on the wound with a clean cloth and keep pressing.',
      'If the person does not respond and is not breathing normally: start chest compressions in the centre of the chest, hard and fast (about 100 to 120 per minute) until help arrives.',
      'Follow the instructions of the ambulance operator on the phone.',
    ],
    careAr: [
      'لا تعطِ طعاماً أو شراباً لشخص فاقد الوعي.',
      'لا تعطِ أدوية لشخص آخر دون نصيحة طبية.',
    ],
    careEn: [
      'Do not give food or drink to an unconscious person.',
      'Do not give medicine to someone else without medical advice.',
    ],
    whenAr: ['دائماً عند فقدان الوعي أو صعوبة التنفس أو ألم الصدر أو نزيف لا يتوقف أو تشنجات أو اشتباه سكتة دماغية.'],
    whenEn: ['Always for loss of consciousness, trouble breathing, chest pain, bleeding that does not stop, seizures, or suspected stroke.'],
    call: ['ambulance'],
    keysAr: ['اسعاف', 'اغماء', 'اغمى', 'مش بيتنفس', 'نزيف', 'دم', 'ضيق نفس', 'الم صدر', 'جلطه', 'سكته', 'تشنج', 'حروق', 'كسر', 'مغمي', 'وقع', 'تسمم', 'مريض', 'اصابه', 'اختناق', 'غرق', 'سكر'],
    keysEn: ['ambulance', 'faint', 'unconscious', 'not breathing', 'bleeding', 'blood', 'chest pain', 'stroke', 'heart attack', 'seizure', 'burn', 'fracture', 'broken', 'choking', 'poison', 'drown', 'injur', 'sick'],
  ),
  Category(
    id: 'fire',
    icon: 'fire',
    titleAr: 'حرائق ودخان',
    titleEn: 'Fires and smoke',
    whatAr: 'حريق في مبنى أو سيارة أو رائحة دخان أو غاز.',
    whatEn: 'A fire in a building or vehicle, or the smell of smoke or gas.',
    stepsAr: [
      'اخرج من المكان فوراً ونبّه الآخرين. لا تعد لأخذ أغراضك.',
      'اتصل بالمطافئ 180 من مكان آمن بعد الخروج.',
      'ازحف قرب الأرض إذا كان الدخان كثيفاً وغطِّ أنفك وفمك بقماش.',
      'المس الباب بظهر يدك قبل فتحه. إذا كان ساخناً لا تفتحه واستخدم مخرجاً آخر.',
      'لا تستخدم المصعد. استخدم السلالم.',
      'إذا اشتعلت ملابسك: توقف، اسقط على الأرض، غطِّ وجهك، وتدحرج.',
    ],
    stepsEn: [
      'Get out immediately and warn others. Do not go back for belongings.',
      'Call the fire service (180) from a safe place once you are outside.',
      'Crawl low under smoke and cover your nose and mouth with cloth.',
      'Touch a door with the back of your hand before opening it. If it is hot, keep it closed and use another exit.',
      'Do not use the lift. Use the stairs.',
      'If your clothes catch fire: stop, drop to the ground, cover your face, and roll.',
    ],
    careAr: [
      'لا تصب الماء على حريق زيت أو كهرباء.',
      'عند رائحة غاز: لا تشعل ولا تطفئ أي أجهزة كهربائية، افتح النوافذ، واخرج، واتصل بطوارئ الغاز 129 من الخارج.',
    ],
    careEn: [
      'Never pour water on an oil or electrical fire.',
      'If you smell gas: do not switch any electrical device on or off, open windows, leave, and call the gas emergency line (129) from outside.',
    ],
    whenAr: ['اتصل دائماً بالمطافئ عند أي حريق لا يمكن إطفاؤه فوراً بأمان، أو عند وجود دخان في مبنى.'],
    whenEn: ['Always call the fire service for any fire you cannot safely put out immediately, or for smoke in a building.'],
    call: ['fire', 'gas'],
    keysAr: ['حريق', 'حرايق', 'نار', 'دخان', 'مطافي', 'اشتعل', 'ولع', 'ولعت', 'غاز', 'تسريب', 'ماس كهربا', 'شرارة', 'بتولع'],
    keysEn: ['fire', 'smoke', 'burning', 'flames', 'gas leak', 'gas smell', 'short circuit', 'sparks'],
  ),
  Category(
    id: 'road',
    icon: 'road',
    titleAr: 'حوادث الطرق',
    titleEn: 'Road accidents',
    whatAr: 'تصادم أو انقلاب أو إصابة على الطريق.',
    whatEn: 'A collision, rollover, or injury on the road.',
    stepsAr: [
      'أوقف السيارة في مكان آمن وشغّل الإنذار (الفلاشر).',
      'اتصل بالإسعاف 123 إذا كان هناك مصابون، وبالنجدة 122 أو المرور 128 للإبلاغ.',
      'لا تحرك المصاب إلا لو كان في خطر مباشر (حريق أو خطر تصادم جديد).',
      'ابتعد عن الطريق إلى مكان آمن خلف الحاجز واترك السيارات في مكانها حتى حضور الشرطة إن أمكن.',
      'سجّل مكانك بدقة: اسم الطريق، رقم الكيلو، أقرب علامة.',
    ],
    stepsEn: [
      'Stop in a safe place and switch on your hazard lights.',
      'Call the ambulance (123) if anyone is hurt, and the police (122) or traffic police (128) to report it.',
      'Do not move an injured person unless there is immediate danger (fire or another collision).',
      'Move yourself away from traffic, behind a barrier if possible.',
      'Note your exact location: road name, kilometre marker, nearest landmark.',
    ],
    careAr: [
      'لا تقف بين السيارات على طريق سريع.',
      'لا تزِل خوذة راكب دراجة نارية مصاب إلا إذا كان لا يتنفس ويلزم ذلك.',
    ],
    careEn: [
      'Do not stand between vehicles on a highway.',
      'Do not remove an injured motorcyclist\'s helmet unless it is needed to help them breathe.',
    ],
    whenAr: ['اتصل دائماً عند وجود مصابين أو سيارة تعيق الطريق أو حريق.'],
    whenEn: ['Always call when anyone is injured, a vehicle blocks the road, or there is fire.'],
    call: ['ambulance', 'traffic', 'police'],
    keysAr: ['حادثه', 'حادث', 'تصادم', 'عربيه', 'عربية', 'سياره', 'انقلب', 'انقلبت', 'طريق', 'موتوسيكل', 'خبطني', 'خبطت'],
    keysEn: ['accident', 'crash', 'collision', 'car', 'road', 'highway', 'motorcycle', 'rollover', 'hit by'],
  ),
  Category(
    id: 'disaster',
    icon: 'disaster',
    titleAr: 'كوارث طبيعية',
    titleEn: 'Natural disasters',
    whatAr: 'زلازل وسيول وعواصف رملية وارتفاع موج البحر.',
    whatEn: 'Earthquakes, flash floods, sandstorms, and rough seas.',
    stepsAr: [
      'زلزال: اخفض جسمك، احتمِ تحت طاولة قوية أو بجانب جدار داخلي، وغطِّ رأسك. ابتعد عن النوافذ. بعد توقف الهزة اخرج بحذر.',
      'سيول: اصعد إلى مكان مرتفع. لا تعبر مياهاً جارية سيراً أو بالسيارة.',
      'عاصفة رملية: ابقَ في مكان مغلق وأغلق النوافذ وغطِّ الأنف والفم.',
      'اتصل بالنجدة 122 أو الحماية المدنية 180 إذا كنت محتجزاً أو مصاباً.',
      'وفّر هاتفك: قلل السطوع واستخدم الرسائل بدل المكالمات الطويلة.',
    ],
    stepsEn: [
      'Earthquake: drop down, take cover under sturdy furniture or next to an interior wall, and protect your head. Stay away from windows. Leave carefully once the shaking stops.',
      'Flash flood: move to higher ground. Never walk or drive through moving water.',
      'Sandstorm: stay indoors, close windows, and cover your nose and mouth.',
      'Call the police (122) or Civil Protection (180) if you are trapped or hurt.',
      'Save phone battery: lower brightness and use messages instead of long calls.',
    ],
    careAr: ['بعد الزلزال توقع هزات لاحقة وتحقق من رائحة الغاز قبل أي شعلة.'],
    careEn: ['Expect aftershocks after an earthquake and check for gas smell before using any flame.'],
    whenAr: ['اتصل عند الإصابة أو الاحتجاز أو انهيار مبنى.'],
    whenEn: ['Call when someone is hurt or trapped, or a building has collapsed.'],
    call: ['fire', 'police', 'ambulance'],
    keysAr: ['زلزال', 'هزه', 'سيول', 'فيضان', 'عاصفه', 'عواصف', 'رمليه', 'كارثه', 'انهيار', 'عقار', 'موج'],
    keysEn: ['earthquake', 'flood', 'storm', 'sandstorm', 'disaster', 'collapse', 'tsunami'],
  ),
  Category(
    id: 'threat',
    icon: 'shield',
    titleAr: 'تهديد على السلامة الشخصية',
    titleEn: 'Personal safety threats',
    whatAr: 'اعتداء أو تحرش أو مطاردة أو سرقة أو شعور بأنك في خطر.',
    whatEn: 'Assault, harassment, being followed, theft, or feeling unsafe.',
    stepsAr: [
      'إذا كنت في خطر الآن: اتصل بالنجدة 122.',
      'اذهب إلى مكان فيه ناس ومضاء، كمحل أو صيدلية أو مسجد أو محطة بنزين.',
      'أرسل موقعك لشخص تثق به من داخل التطبيق (زر SOS).',
      'لا تواجه المعتدي. سلامتك أهم من ممتلكاتك.',
      'بعد الأمان: دوّن ما حدث (الوقت، المكان، الأوصاف) للإبلاغ.',
    ],
    stepsEn: [
      'If you are in danger right now: call the police (122).',
      'Move to a busy, well-lit place such as a shop, pharmacy, mosque, or fuel station.',
      'Send your location to someone you trust using the SOS button in this app.',
      'Do not confront the attacker. Your safety matters more than belongings.',
      'Once safe: write down what happened (time, place, descriptions) for a report.',
    ],
    careAr: ['لا تشارك موقعك علناً. أرسله فقط لجهات اتصالك الموثوقة.'],
    careEn: ['Do not share your location publicly. Send it only to trusted contacts.'],
    whenAr: ['اتصل فوراً عند أي تهديد مباشر بالعنف أو الاحتجاز.'],
    whenEn: ['Call immediately for any direct threat of violence or being held against your will.'],
    call: ['police', 'child'],
    keysAr: ['تحرش', 'بيتبعني', 'ماشي ورايا', 'سرقه', 'حرامي', 'اعتداء', 'بيضربني', 'خطف', 'تهديد', 'خايف', 'مطاردة', 'سلاح', 'بلطجي', 'عنف'],
    keysEn: ['harass', 'following', 'followed', 'stalk', 'theft', 'robber', 'attack', 'assault', 'kidnap', 'threat', 'scared', 'weapon', 'violence', 'abuse'],
  ),
  Category(
    id: 'missing',
    icon: 'search',
    titleAr: 'أشخاص مفقودون',
    titleEn: 'Missing persons',
    whatAr: 'طفل أو شخص تائه أو لا يمكن الوصول إليه.',
    whatEn: 'A child or person who is lost or cannot be reached.',
    stepsAr: [
      'ابحث في المكان القريب وأبلغ الأمن أو الأشخاص حولك فوراً.',
      'اتصل بالنجدة 122 للإبلاغ. للطفل يمكن الاتصال أيضاً بنجدة الطفل 16000.',
      'جهّز: صورة حديثة، الملابس التي كان يرتديها، آخر مكان شوهد فيه، أي حالة صحية.',
      'اتصل بأقاربه وأصدقائه وأرسل لهم موقع آخر ظهور.',
      'ابقَ في مكان الفقد أو قريب منه ليسهل العثور عليك.',
    ],
    stepsEn: [
      'Search the immediate area and alert security staff or people nearby right away.',
      'Call the police (122) to report. For a child you can also call the child helpline (16000).',
      'Prepare: a recent photo, what they were wearing, last place seen, any health condition.',
      'Contact their relatives and friends and share the last known location.',
      'Stay at or near the place where they were lost so they can find you.',
    ],
    careAr: ['لا تنتظر مدة معينة للإبلاغ عن طفل مفقود.'],
    careEn: ['Do not wait a set amount of time before reporting a missing child.'],
    whenAr: ['اتصل فوراً في حالة الأطفال وكبار السن والمرضى.'],
    whenEn: ['Call immediately for children, older people, or people with health conditions.'],
    call: ['police', 'child'],
    keysAr: ['مفقود', 'ضايع', 'تايه', 'اختفى', 'اختفت', 'مش لاقيه', 'مش لاقي', 'ضاع', 'طفل'],
    keysEn: ['missing', 'lost child', 'lost', 'disappeared', 'cannot find'],
  ),
  Category(
    id: 'environment',
    icon: 'leaf',
    titleAr: 'مخاطر بيئية',
    titleEn: 'Environmental hazards',
    whatAr: 'تلوث هواء أو تسرب مواد أو حرارة شديدة أو مياه ملوثة.',
    whatEn: 'Air pollution, chemical spills, extreme heat, or contaminated water.',
    stepsAr: [
      'ابتعد عن مصدر الخطر وتحرك عكس اتجاه الرياح.',
      'أغلق النوافذ وأوقف أجهزة التكييف التي تسحب هواء من الخارج عند تسرب خارجي.',
      'حرارة شديدة: انتقل لمكان بارد، اشرب ماء، وبرّد الجسم. إذا ظهر دوار أو ارتباك اتصل بالإسعاف 123.',
      'مواد كيميائية: لا تلمسها. اتصل بالحماية المدنية 180.',
      'مياه ملوثة: لا تشربها. استخدم مياهاً مغلية أو معبأة حتى تتأكد.',
    ],
    stepsEn: [
      'Move away from the hazard and upwind of it.',
      'For an outside release, close windows and switch off air conditioning that draws in outside air.',
      'Extreme heat: move somewhere cool, drink water, and cool the body. If dizziness or confusion appears, call the ambulance (123).',
      'Chemicals: do not touch them. Call Civil Protection (180).',
      'Contaminated water: do not drink it. Use boiled or bottled water until it is confirmed safe.',
    ],
    careAr: ['لا تخلط مواد التنظيف مع بعضها.'],
    careEn: ['Never mix cleaning chemicals together.'],
    whenAr: ['اتصل عند صعوبة التنفس أو الدوار الشديد أو تسرب مواد خطرة.'],
    whenEn: ['Call for trouble breathing, severe dizziness, or a hazardous material release.'],
    call: ['fire', 'ambulance'],
    keysAr: ['تلوث', 'كيماويات', 'مواد كيميائية', 'سموم', 'حراره', 'ضربة شمس', 'مياه ملوثه', 'تسرب', 'سحابه', 'اشعاع'],
    keysEn: ['pollution', 'chemical', 'spill', 'toxic', 'heat stroke', 'heatwave', 'contaminated', 'radiation'],
  ),
  Category(
    id: 'other',
    icon: 'alert',
    titleAr: 'حالات عاجلة أخرى',
    titleEn: 'Other urgent situations',
    whatAr: 'أي موقف عاجل لا يندرج تحت الأقسام السابقة.',
    whatEn: 'Any urgent situation that does not fit the sections above.',
    stepsAr: [
      'ابتعد عن الخطر أولاً.',
      'إذا كانت حياة أحد في خطر اتصل بالنجدة 122 أو الإسعاف 123 أو المطافئ 180 حسب الحالة.',
      'قل بوضوح: أين أنت، ماذا حدث، كم شخصاً مصاباً، واسمك ورقمك.',
      'لا تغلق الخط حتى يخبرك المشغل.',
    ],
    stepsEn: [
      'Get away from danger first.',
      'If anyone\'s life is at risk call the police (122), ambulance (123), or fire service (180) as appropriate.',
      'Say clearly: where you are, what happened, how many people are hurt, and your name and number.',
      'Do not hang up until the operator tells you to.',
    ],
    careAr: ['هذا التطبيق لا يحل محل خدمات الطوارئ.'],
    careEn: ['This app does not replace emergency services.'],
    whenAr: ['إذا كنت غير متأكد، اتصل. المشغل سيوجهك.'],
    whenEn: ['If you are unsure, call. The operator will guide you.'],
    call: ['police', 'ambulance', 'fire'],
    keysAr: [],
    keysEn: [],
  ),
];

Category catById(String id) => categories.firstWhere((c) => c.id == id);
Svc svcById(String id) => services.firstWhere((s) => s.id == id);

class Lesson {
  final String titleAr, titleEn, icon;
  final List<String> pointsAr, pointsEn;
  const Lesson(this.titleAr, this.titleEn, this.icon, this.pointsAr, this.pointsEn);
}

const lessons = <Lesson>[
  Lesson('الوعي بالسلامة الشخصية', 'Personal safety awareness', 'shield', [
    'أبلغ شخصاً تثق به بوجهتك ووقت عودتك المتوقع.',
    'تجنب الأماكن المعزولة وغير المضاءة ليلاً إن أمكن.',
    'ثق بإحساسك: إذا شعرت بعدم الأمان غيّر طريقك.',
    'احتفظ بالهاتف مشحوناً واحفظ أرقام الطوارئ وجهات الاتصال.',
  ], [
    'Tell someone you trust where you are going and when you expect to be back.',
    'Avoid isolated or unlit places at night when you can.',
    'Trust your instincts: if you feel unsafe, change your route.',
    'Keep your phone charged and your emergency numbers and contacts saved.',
  ]),
  Lesson('الاستعداد للطوارئ', 'Emergency preparedness', 'list', [
    'جهّز حقيبة طوارئ: ماء، أدوية أساسية، كشاف، شاحن متنقل، نسخ أوراق مهمة.',
    'اتفق مع أسرتك على مكان تجمع وخطة اتصال.',
    'اعرف مخارج الطوارئ في بيتك وعملك.',
    'راجع الحقيبة والأدوية كل 6 أشهر تقريباً.',
  ], [
    'Prepare a go-bag: water, essential medicines, torch, power bank, copies of key documents.',
    'Agree on a meeting place and a contact plan with your family.',
    'Know the emergency exits at home and work.',
    'Check the bag and medicines about every 6 months.',
  ]),
  Lesson('الوقاية من الحرائق', 'Fire prevention', 'fire', [
    'لا تترك الطبخ دون مراقبة.',
    'لا تحمّل مشترك الكهرباء فوق طاقته ولا تترك الأجهزة تسخن.',
    'ركّب كاشف دخان وجهز طفاية حريق صالحة واعرف استخدامها.',
    'افحص خراطيم وأسطوانات الغاز دورياً ولا تخزن مواد قابلة للاشتعال قرب الحرارة.',
  ], [
    'Never leave cooking unattended.',
    'Do not overload power strips or leave heating devices running unattended.',
    'Install a smoke detector, keep a valid fire extinguisher, and know how to use it.',
    'Check gas hoses and cylinders regularly and keep flammables away from heat.',
  ]),
  Lesson('السلامة على الطرق', 'Road safety', 'road', [
    'اربط حزام الأمان دائماً وأجلس الأطفال في المقاعد الخلفية.',
    'لا تستخدم الهاتف أثناء القيادة.',
    'التزم بالسرعة المحددة وأبقِ مسافة أمان.',
    'ارتدِ خوذة على الدراجة النارية.',
  ], [
    'Always wear a seat belt and seat children in the back.',
    'Do not use your phone while driving.',
    'Keep to speed limits and keep a safe following distance.',
    'Wear a helmet on a motorcycle.',
  ]),
  Lesson('الاستعداد للكوارث', 'Disaster preparedness', 'disaster', [
    'اعرف المخاطر في منطقتك (سيول، زلازل، عواصف).',
    'ثبّت الأثاث الثقيل والرفوف على الجدران.',
    'احتفظ بمصدر إضاءة وراديو وبطاريات.',
    'تعلم قطع الكهرباء والغاز والمياه عند الحاجة.',
  ], [
    'Know the hazards in your area (floods, earthquakes, storms).',
    'Secure heavy furniture and shelves to walls.',
    'Keep a light source, radio, and spare batteries.',
    'Learn how to switch off electricity, gas, and water when needed.',
  ]),
  Lesson('إسعافات أولية أساسية', 'Basic first-aid awareness', 'medical', [
    'هذه معلومات توعية وليست بديلاً عن دورة إسعافات معتمدة.',
    'نزيف: ضغط مباشر وقوي على الجرح.',
    'حروق بسيطة: برّد بماء جارٍ عادي (ليس مثلجاً) لمدة 20 دقيقة تقريباً.',
    'اختناق شخص بالغ واعٍ: شجعه على السعال. إن لم يستطع التنفس أو الكلام اتصل بالإسعاف 123 وابدأ إسعاف الاختناق إذا كنت متدرباً.',
    'تعلّم الإنعاش القلبي الرئوي من جهة معتمدة كالهلال الأحمر المصري.',
  ], [
    'This is awareness information, not a substitute for a certified first-aid course.',
    'Bleeding: firm, direct pressure on the wound.',
    'Minor burns: cool with running tap water (not ice) for about 20 minutes.',
    'Conscious adult choking: encourage coughing. If they cannot breathe or speak call the ambulance (123) and start choking first aid if trained.',
    'Learn CPR from an accredited provider such as the Egyptian Red Crescent.',
  ]),
];

const sourcesAr = <String>[
  'أرقام الطوارئ: بوابات المحافظات الرسمية (كفر الشيخ، الجيزة) وجهاز حماية المستهلك.',
  'التوعية العامة: الصليب الأحمر، منظمة الصحة العالمية، Ready.gov.',
];
const sourcesEn = <String>[
  'Emergency numbers: official governorate portals (Kafr El-Sheikh, Giza) and the Consumer Protection Agency.',
  'General awareness: Red Cross, World Health Organization, Ready.gov.',
];
const sourceLinks = <String>[
  'https://www.redcross.org/get-help/how-to-prepare-for-emergencies.html',
  'https://www.who.int/news-room/fact-sheets/detail/road-traffic-injuries',
  'https://www.ready.gov/',
];

class CheckItem {
  final String id, ar, en;
  const CheckItem(this.id, this.ar, this.en);
}

const checklist = <CheckItem>[
  CheckItem('water', 'ماء للشرب (3 أيام تقريباً)', 'Drinking water (about 3 days)'),
  CheckItem('meds', 'أدوية أساسية وشخصية', 'Essential and personal medicines'),
  CheckItem('light', 'كشاف وبطاريات', 'Torch and batteries'),
  CheckItem('power', 'شاحن متنقل', 'Power bank'),
  CheckItem('docs', 'نسخ من الأوراق المهمة', 'Copies of key documents'),
  CheckItem('firstaid', 'حقيبة إسعافات أولية', 'First-aid kit'),
  CheckItem('cash', 'نقود احتياطية', 'Some spare cash'),
  CheckItem('plan', 'خطة اتصال ومكان تجمع للأسرة', 'Family contact plan and meeting place'),
  CheckItem('contacts', 'أرقام الطوارئ مكتوبة على ورقة', 'Emergency numbers written on paper'),
  CheckItem('extinguisher', 'طفاية حريق صالحة وكاشف دخان', 'Valid fire extinguisher and smoke detector'),
];
