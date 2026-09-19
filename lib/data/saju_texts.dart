/// 사주 해석 콘텐츠 (ko / en / ja / zh).
///
/// 모든 항목은 [T] 로 4개 언어를 함께 갖는다. 인덱스로 참조하므로 한 언어만
/// 추가·삭제하면 안 된다.
library;

import '../saju/saju.dart';

/// 4개 언어 텍스트.
class T {
  final String ko;
  final String en;
  final String ja;
  final String zh;
  const T(this.ko, this.en, this.ja, this.zh);

  String of(String lang) => switch (lang) {
        'ko' => ko,
        'ja' => ja,
        'zh' => zh,
        _ => en,
      };
}

class SajuTexts {
  SajuTexts._();

  /// 지원 언어. 이 외의 시스템 언어는 영어로 폴백.
  static const supportedLangs = ['ko', 'en', 'ja', 'zh'];

  // ---------------------------------------------------------------- 천간 · 지지

  /// 천간 읽기 (한자는 [Saju.stemHanja]).
  static const stemNames = [
    T('갑', 'Jia', 'きのえ', '甲'),
    T('을', 'Yi', 'きのと', '乙'),
    T('병', 'Bing', 'ひのえ', '丙'),
    T('정', 'Ding', 'ひのと', '丁'),
    T('무', 'Wu', 'つちのえ', '戊'),
    T('기', 'Ji', 'つちのと', '己'),
    T('경', 'Geng', 'かのえ', '庚'),
    T('신', 'Xin', 'かのと', '辛'),
    T('임', 'Ren', 'みずのえ', '壬'),
    T('계', 'Gui', 'みずのと', '癸'),
  ];

  /// 천간의 자연 이미지 (일간 캐릭터).
  static const stemImages = [
    T('큰 나무', 'Tall Tree', '大樹', '大树'),
    T('풀과 꽃', 'Grass & Flowers', '草花', '花草'),
    T('태양', 'Sun', '太陽', '太阳'),
    T('촛불', 'Candle Flame', 'ろうそくの火', '烛火'),
    T('큰 산', 'Mountain', '大山', '高山'),
    T('논밭', 'Fertile Field', '田畑', '田园'),
    T('바위와 쇠', 'Iron & Rock', '岩と鉄', '岩石金属'),
    T('보석', 'Jewel', '宝石', '珠宝'),
    T('바다', 'Ocean', '海', '大海'),
    T('빗물', 'Rain', '雨', '雨露'),
  ];

  static const stemEmoji = ['🌳', '🌷', '☀️', '🕯️', '⛰️', '🌾', '⚔️', '💎', '🌊', '🌧️'];

  /// 지지 읽기.
  static const branchNames = [
    T('자', 'Zi', 'ね', '子'),
    T('축', 'Chou', 'うし', '丑'),
    T('인', 'Yin', 'とら', '寅'),
    T('묘', 'Mao', 'う', '卯'),
    T('진', 'Chen', 'たつ', '辰'),
    T('사', 'Si', 'み', '巳'),
    T('오', 'Wu', 'うま', '午'),
    T('미', 'Wei', 'ひつじ', '未'),
    T('신', 'Shen', 'さる', '申'),
    T('유', 'You', 'とり', '酉'),
    T('술', 'Xu', 'いぬ', '戌'),
    T('해', 'Hai', 'い', '亥'),
  ];

  /// 띠 (지지 순서 = 子 쥐 … 亥 돼지).
  static const zodiacAnimals = [
    T('쥐', 'Rat', 'ねずみ', '鼠'),
    T('소', 'Ox', 'うし', '牛'),
    T('호랑이', 'Tiger', 'とら', '虎'),
    T('토끼', 'Rabbit', 'うさぎ', '兔'),
    T('용', 'Dragon', 'たつ', '龙'),
    T('뱀', 'Snake', 'へび', '蛇'),
    T('말', 'Horse', 'うま', '马'),
    T('양', 'Goat', 'ひつじ', '羊'),
    T('원숭이', 'Monkey', 'さる', '猴'),
    T('닭', 'Rooster', 'とり', '鸡'),
    T('개', 'Dog', 'いぬ', '狗'),
    T('돼지', 'Pig', 'いのしし', '猪'),
  ];

  static const zodiacEmoji = ['🐭', '🐮', '🐯', '🐰', '🐲', '🐍', '🐴', '🐑', '🐵', '🐔', '🐶', '🐷'];

  // ---------------------------------------------------------------- 오행

  static const elementNames = [
    T('목(木)', 'Wood (木)', '木', '木'),
    T('화(火)', 'Fire (火)', '火', '火'),
    T('토(土)', 'Earth (土)', '土', '土'),
    T('금(金)', 'Metal (金)', '金', '金'),
    T('수(水)', 'Water (水)', '水', '水'),
  ];

  static const elementShort = [
    T('목', 'Wood', '木', '木'),
    T('화', 'Fire', '火', '火'),
    T('토', 'Earth', '土', '土'),
    T('금', 'Metal', '金', '金'),
    T('수', 'Water', '水', '水'),
  ];

  static const elementKeywords = [
    T('성장 · 시작 · 인자함', 'Growth · Beginnings · Kindness', '成長・始まり・仁', '成长 · 开始 · 仁'),
    T('열정 · 표현 · 예의', 'Passion · Expression · Courtesy', '情熱・表現・礼', '热情 · 表达 · 礼'),
    T('안정 · 신뢰 · 포용', 'Stability · Trust · Acceptance', '安定・信頼・信', '稳定 · 信任 · 信'),
    T('결단 · 원칙 · 의리', 'Decisiveness · Principle · Loyalty', '決断・原則・義', '果断 · 原则 · 义'),
    T('지혜 · 유연함 · 소통', 'Wisdom · Flexibility · Communication', '知恵・柔軟・智', '智慧 · 灵活 · 智'),
  ];

  static const elementColors = [
    T('초록색', 'Green', '緑', '绿色'),
    T('빨간색', 'Red', '赤', '红色'),
    T('노란색', 'Yellow', '黄', '黄色'),
    T('흰색', 'White', '白', '白色'),
    T('검은색 · 파란색', 'Black · Blue', '黒・青', '黑色 · 蓝色'),
  ];

  static const elementDirections = [
    T('동쪽', 'East', '東', '东方'),
    T('남쪽', 'South', '南', '南方'),
    T('중앙', 'Center', '中央', '中央'),
    T('서쪽', 'West', '西', '西方'),
    T('북쪽', 'North', '北', '北方'),
  ];

  /// 오행이 많을 때.
  static const elementStrong = [
    T('목(木) 기운이 강해요. 새로운 일을 벌이고 키우는 힘이 크고 마음이 너그럽지만, 계획이 너무 많아 마무리가 약해질 수 있어요. 하나를 끝까지 밀어붙이는 연습이 도움이 돼요.',
      'Wood is strong in your chart. You start and grow things easily and have a generous heart, but too many plans can leave things unfinished. Practice seeing one thing through to the end.',
      '木の気が強いです。新しいことを始めて育てる力が大きく寛大ですが、計画が多すぎて仕上げが弱くなりがち。ひとつをやり遂げる練習が助けになります。',
      '木气旺盛。你善于开创并培育新事物，心胸宽广，但计划太多容易虎头蛇尾。练习把一件事坚持做到底会很有帮助。'),
    T('화(火) 기운이 강해요. 열정적이고 표현력이 풍부해 사람들을 끌어당기지만, 급한 성격과 감정 기복이 관계를 흔들 수 있어요. 한 박자 쉬고 말하는 습관이 큰 자산이 돼요.',
      'Fire is strong in your chart. Passionate and expressive, you draw people in, yet impatience and mood swings can strain relationships. Pausing a beat before you speak becomes a real asset.',
      '火の気が強いです。情熱的で表現力豊かに人を惹きつけますが、せっかちさや感情の波が関係を揺らすことも。一呼吸おいて話す習慣が大きな財産になります。',
      '火气旺盛。你热情且富有表现力，很有吸引力，但急躁和情绪起伏可能影响人际关系。说话前停一拍的习惯会成为你的财富。'),
    T('토(土) 기운이 강해요. 묵직하고 믿음직해 주변이 의지하지만, 변화를 꺼리고 고집이 세질 수 있어요. 가끔은 낯선 선택을 해보는 게 삶을 넓혀 줘요.',
      'Earth is strong in your chart. Steady and dependable, people lean on you, but you may resist change and grow stubborn. An unfamiliar choice now and then widens your world.',
      '土の気が強いです。どっしりと頼もしく周囲に頼られますが、変化を嫌い頑固になりがち。時には慣れない選択をしてみると人生が広がります。',
      '土气旺盛。你稳重可靠，周围人都依赖你，但可能抗拒变化、固执己见。偶尔做些陌生的选择会让人生更宽广。'),
    T('금(金) 기운이 강해요. 원칙이 분명하고 결단이 빨라 일 처리가 깔끔하지만, 말이 날카로워 상처를 줄 수 있어요. 부드러운 표현 하나가 사람을 얻게 해요.',
      'Metal is strong in your chart. Clear principles and quick decisions make you efficient, but sharp words can wound. One softer phrase wins people over.',
      '金の気が強いです。原則がはっきりし決断が早く仕事がきれいですが、言葉が鋭く人を傷つけることも。やわらかい一言が人を得ます。',
      '金气旺盛。你原则分明、决断迅速，做事干脆，但言辞锋利可能伤人。一句温和的话就能赢得人心。'),
    T('수(水) 기운이 강해요. 머리가 좋고 유연해 어디서든 적응하지만, 생각이 많아 걱정과 우유부단함에 빠질 수 있어요. 몸을 움직이면 마음이 가벼워져요.',
      'Water is strong in your chart. Bright and adaptable, you fit in anywhere, but overthinking can spiral into worry and indecision. Moving your body lightens your mind.',
      '水の気が強いです。頭が良く柔軟でどこでも適応しますが、考えすぎて心配や優柔不断に陥ることも。体を動かすと心が軽くなります。',
      '水气旺盛。你聪明灵活，随处都能适应，但想得太多容易陷入忧虑和犹豫。多活动身体，心情就会轻松。'),
  ];

  /// 오행이 없거나 적을 때 (보완 오행 안내).
  static const elementWeak = [
    T('목(木) 기운이 부족해요. 시작하는 힘과 유연함을 채우면 좋아요. 초록색, 식물, 아침 산책, 동쪽 방향이 목 기운을 보태 줘요.',
      'Wood is weak in your chart. Strengthen your drive to start and your flexibility. Green, plants, morning walks and the east add Wood energy.',
      '木の気が不足しています。始める力と柔軟さを補いましょう。緑、植物、朝の散歩、東の方角が木の気を足してくれます。',
      '木气不足。宜补充开创力与灵活性。绿色、植物、晨间散步和东方能增添木气。'),
    T('화(火) 기운이 부족해요. 열정과 표현력을 조금 더 꺼내 보세요. 빨간색, 햇빛, 밝은 조명, 남쪽 방향이 화 기운을 보태 줘요.',
      'Fire is weak in your chart. Bring out a little more passion and self-expression. Red, sunlight, bright lighting and the south add Fire energy.',
      '火の気が不足しています。情熱と表現力をもう少し出してみましょう。赤、日光、明るい照明、南の方角が火の気を足してくれます。',
      '火气不足。多释放一些热情与表现力吧。红色、阳光、明亮的灯光和南方能增添火气。'),
    T('토(土) 기운이 부족해요. 꾸준함과 안정감을 의식적으로 챙기면 좋아요. 노란색, 흙과 도자기, 규칙적인 식사가 토 기운을 보태 줘요.',
      'Earth is weak in your chart. Consciously build steadiness and stability. Yellow, clay and ceramics, and regular meals add Earth energy.',
      '土の気が不足しています。継続力と安定感を意識して補いましょう。黄色、土や陶器、規則正しい食事が土の気を足してくれます。',
      '土气不足。要有意识地培养稳定与坚持。黄色、泥土与陶器、规律的饮食能增添土气。'),
    T('금(金) 기운이 부족해요. 결단력과 마무리 습관을 기르면 좋아요. 흰색, 금속 액세서리, 정리정돈, 서쪽 방향이 금 기운을 보태 줘요.',
      'Metal is weak in your chart. Build decisiveness and the habit of finishing. White, metal accessories, tidiness and the west add Metal energy.',
      '金の気が不足しています。決断力と仕上げる習慣を育てましょう。白、金属アクセサリー、整理整頓、西の方角が金の気を足してくれます。',
      '金气不足。宜培养决断力与善始善终的习惯。白色、金属饰品、整理收纳和西方能增添金气。'),
    T('수(水) 기운이 부족해요. 휴식과 생각의 여유를 챙기면 좋아요. 검은색·파란색, 물을 자주 마시기, 조용한 독서, 북쪽 방향이 수 기운을 보태 줘요.',
      'Water is weak in your chart. Make room for rest and reflection. Black and blue, drinking water often, quiet reading and the north add Water energy.',
      '水の気が不足しています。休息と考える余裕を確保しましょう。黒・青、こまめな水分補給、静かな読書、北の方角が水の気を足してくれます。',
      '水气不足。要给自己留出休息与思考的空间。黑色与蓝色、常喝水、安静阅读和北方能增添水气。'),
  ];

  // ---------------------------------------------------------------- 일간 성격

  /// 일간(日干)별 성격. 인덱스 = 천간.
  static const dayMaster = [
    T('갑목(甲木)은 하늘로 곧게 뻗는 큰 나무예요. 리더십이 있고 정직하며, 한번 정한 방향으로 흔들림 없이 나아가요. 자존심이 강해 굽히기 어렵지만, 그 곧음이 사람들에게 신뢰를 줘요. 자기 뜻을 세우고 남을 이끄는 자리에서 빛나요.',
      'Jia Wood is a tall tree reaching straight for the sky. You are a natural leader, honest and unwavering once you choose a direction. Pride makes bending hard, but that very straightness earns trust. You shine where you can set your own course and lead others.',
      '甲木は空へまっすぐ伸びる大樹。リーダーシップがあり正直で、一度決めた方向へ揺るがず進みます。プライドが高く曲げにくいですが、その真っ直ぐさが信頼を生みます。自分の志を立て人を導く場で輝きます。',
      '甲木是笔直向上生长的大树。你有领导力、正直，一旦确定方向便坚定前行。自尊心强、不易低头，但正是这份正直赢得信任。在能立定志向、带领他人的位置上最能发光。'),
    T('을목(乙木)은 바람에 흔들려도 꺾이지 않는 풀과 꽃이에요. 부드럽고 사교적이며 어떤 환경에도 적응하는 생명력이 있어요. 겉은 유연해 보여도 속은 끈질기고, 사람의 마음을 읽는 감각이 뛰어나요. 협력과 조율이 필요한 곳에서 힘을 발휘해요.',
      'Yi Wood is the grass and flowers that bend in the wind without breaking. Gentle and sociable, you adapt to any environment with quiet vitality. Flexible outside yet tenacious inside, you read people well. You excel where cooperation and coordination matter.',
      '乙木は風に揺れても折れない草花。柔らかく社交的で、どんな環境にも適応する生命力があります。外は柔軟に見えても内は粘り強く、人の心を読む感覚に優れます。協力と調整が必要な場で力を発揮します。',
      '乙木是随风摇曳却不折断的花草。你温和、善于社交，在任何环境都有适应的生命力。外表柔软内心坚韧，善于察言观色。在需要协作与协调的地方最能发挥。'),
    T('병화(丙火)는 세상을 고루 비추는 태양이에요. 밝고 화끈하며 숨김이 없어 어디서나 눈에 띄어요. 베풀기를 좋아하고 열정이 넘치지만, 뒷심이 약하고 감정을 잘 감추지 못해요. 사람들 앞에 서서 에너지를 나누는 일이 잘 맞아요.',
      'Bing Fire is the sun that shines on everyone alike. Bright, bold and unhidden, you stand out anywhere. Generous and full of passion, you may lack staying power and struggle to hide feelings. Work that puts you in front of people, sharing energy, suits you.',
      '丙火は世界をあまねく照らす太陽。明るく豪快で隠し事がなく、どこでも目立ちます。与えることを好み情熱にあふれますが、持久力が弱く感情を隠せません。人前に立ちエネルギーを分かち合う仕事が向いています。',
      '丙火是普照万物的太阳。你明亮爽朗、毫不掩饰，走到哪里都很显眼。乐于付出、热情洋溢，但后劲不足、不善藏情绪。适合站在人前、传递能量的工作。'),
    T('정화(丁火)는 어둠 속을 따뜻하게 밝히는 촛불이에요. 겉은 조용하지만 속은 뜨겁고, 섬세하게 주변을 살피는 배려가 있어요. 한 사람에게 깊이 집중하고 오래 타오르는 힘이 있어요. 전문성과 정성이 필요한 분야에서 존재감이 커져요.',
      'Ding Fire is a candle that warms the dark. Quiet on the surface, hot within, you notice and care for the people around you. You focus deeply on one person or craft and burn long. Fields that reward expertise and devotion make you stand out.',
      '丁火は闇を温かく照らすろうそくの火。外は静かでも内は熱く、繊細に周囲を気遣います。一人に深く集中し長く燃え続ける力があります。専門性と真心が求められる分野で存在感が増します。',
      '丁火是温暖照亮黑暗的烛火。你外表安静内心炽热，细腻体贴周围的人。能对一人一事深度专注、持久燃烧。在需要专业与用心的领域存在感越来越强。'),
    T('무토(戊土)는 묵묵히 자리를 지키는 큰 산이에요. 듬직하고 포용력이 커서 사람들이 기대고, 쉽게 흔들리지 않아요. 다만 변화가 느리고 속마음을 잘 드러내지 않아 답답해 보일 수 있어요. 중심을 잡고 여러 사람을 품는 역할에 어울려요.',
      'Wu Earth is a great mountain standing firm in silence. Reliable and embracing, people lean on you and you are hard to shake. Yet you change slowly and keep feelings inside, which can seem distant. Roles that hold the center and shelter many suit you.',
      '戊土は黙って場所を守る大山。頼もしく包容力が大きく人に頼られ、簡単には揺れません。ただ変化が遅く本心を見せないため、もどかしく見えることも。中心を担い多くの人を包む役割に向いています。',
      '戊土是默默守护的高山。你厚重有包容力，让人依靠且不易动摇。但变化较慢、不轻易流露内心，可能显得沉闷。适合稳住中心、包容众人的角色。'),
    T('기토(己土)는 무엇이든 자라게 하는 기름진 논밭이에요. 온화하고 현실적이며 남을 돌보는 마음이 깊어요. 겉으로는 순해 보여도 속으로는 계산이 빠르고 실속을 챙겨요. 사람을 키우고 살림을 꾸리는 일에서 진가가 드러나요.',
      'Ji Earth is fertile soil where anything can grow. Warm, practical and deeply caring, you look gentle but think quickly and mind the substance. Nurturing people and managing resources reveal your true worth.',
      '己土は何でも育てる肥えた田畑。温和で現実的、人を世話する心が深いです。外は穏やかに見えても内は計算が早く実を取ります。人を育て暮らしを営む仕事で真価が現れます。',
      '己土是滋养万物的肥沃田地。你温和务实，照顾他人的心很深。外表顺和，内心精打细算、注重实际。在培养人才、经营生活的事上显出真本事。'),
    T('경금(庚金)은 단단한 바위와 쇠예요. 의리와 원칙이 분명하고 결단이 빠르며, 불의를 참지 못해요. 직설적이라 오해를 사기도 하지만 뒤끝이 없어요. 강한 추진력으로 어려운 일을 돌파하는 자리에서 빛나요.',
      'Geng Metal is hard rock and iron. Loyal and principled, you decide fast and cannot stand injustice. Bluntness may cause misunderstandings, but you hold no grudges. You shine where strong drive is needed to break through hard problems.',
      '庚金は硬い岩と鉄。義理と原則が明確で決断が早く、不正を許しません。直球すぎて誤解を招くこともありますが、あとに引きずりません。強い推進力で困難を突破する場で輝きます。',
      '庚金是坚硬的岩石与钢铁。你重情义、讲原则、决断迅速，见不得不公。说话直接容易被误解，但不记仇。在需要强大推动力突破难关的地方最能发光。'),
    T('신금(辛金)은 갈고닦아 빛나는 보석이에요. 섬세하고 예리하며 완벽을 추구해요. 자존심이 강하고 상처를 오래 기억하지만, 그만큼 자기 관리가 철저해요. 정교함과 감각이 필요한 전문 분야에서 두각을 나타내요.',
      'Xin Metal is a jewel polished to a shine. Delicate, sharp and perfectionistic, you have strong pride and long memory for hurts, but equally strict self-discipline. You stand out in specialized fields that demand precision and taste.',
      '辛金は磨かれて輝く宝石。繊細で鋭く完璧を求めます。プライドが高く傷を長く覚えますが、その分自己管理が徹底しています。精巧さとセンスが必要な専門分野で頭角を現します。',
      '辛金是打磨后熠熠生辉的珠宝。你细腻敏锐、追求完美。自尊心强、记得住伤害，但也因此自我管理严格。在需要精细与品味的专业领域崭露头角。'),
    T('임수(壬水)는 끝없이 흐르는 넓은 바다예요. 지혜롭고 포용력이 크며 스케일이 커요. 자유를 사랑해 틀에 갇히는 걸 싫어하고, 생각이 깊어 속을 다 보여주지 않아요. 큰 그림을 그리고 여러 분야를 넘나드는 일에 어울려요.',
      'Ren Water is the vast ocean that never stops moving. Wise, embracing and large in scale, you love freedom and hate being boxed in; your deep mind rarely shows everything. Work that draws the big picture across many fields suits you.',
      '壬水は果てしなく流れる広い海。知恵深く包容力が大きくスケールも大きい。自由を愛し型にはまるのを嫌い、思慮深く本心を全ては見せません。大きな絵を描き複数分野を横断する仕事に向いています。',
      '壬水是奔流不息的大海。你智慧、包容、格局大。热爱自由、不喜欢被束缚，思虑深沉，不会把内心全部展露。适合描绘大局、跨领域的工作。'),
    T('계수(癸水)는 조용히 스며드는 빗물이에요. 감수성이 풍부하고 눈치가 빨라 상대의 마음을 잘 헤아려요. 겉은 여려 보여도 어디든 스며드는 끈기와 적응력이 있어요. 사람의 마음을 다루거나 세밀한 연구를 하는 일에서 강점이 살아요.',
      'Gui Water is rain that quietly seeps in. Sensitive and perceptive, you sense what others feel. You look delicate but have the persistence and adaptability to reach anywhere. Your strengths show in work with people\'s hearts or in detailed research.',
      '癸水は静かに染み込む雨。感受性が豊かで察しが早く、相手の心をよく汲みます。外は繊細に見えてもどこへでも染み込む粘りと適応力があります。人の心を扱う仕事や緻密な研究で強みが生きます。',
      '癸水是悄然渗透的雨露。你感性丰富、善于察觉他人的心思。外表柔弱，却有渗透一切的韧性与适应力。在处理人心或精细研究的工作中优势尽显。'),
  ];

  // ---------------------------------------------------------------- 십신

  static const tenGodNames = [
    T('비견', 'Friend (比肩)', '比肩', '比肩'),
    T('겁재', 'Rival (劫財)', '劫財', '劫财'),
    T('식신', 'Eating God (食神)', '食神', '食神'),
    T('상관', 'Hurting Officer (傷官)', '傷官', '伤官'),
    T('편재', 'Indirect Wealth (偏財)', '偏財', '偏财'),
    T('정재', 'Direct Wealth (正財)', '正財', '正财'),
    T('편관', 'Seven Killings (偏官)', '偏官', '七杀'),
    T('정관', 'Direct Officer (正官)', '正官', '正官'),
    T('편인', 'Indirect Resource (偏印)', '偏印', '偏印'),
    T('정인', 'Direct Resource (正印)', '正印', '正印'),
  ];

  static const tenGodShort = [
    T('비견', 'Friend', '比肩', '比肩'),
    T('겁재', 'Rival', '劫財', '劫财'),
    T('식신', 'Eating', '食神', '食神'),
    T('상관', 'Hurting', '傷官', '伤官'),
    T('편재', 'Ind.Wealth', '偏財', '偏财'),
    T('정재', 'Dir.Wealth', '正財', '正财'),
    T('편관', '7 Killings', '偏官', '七杀'),
    T('정관', 'Officer', '正官', '正官'),
    T('편인', 'Ind.Res.', '偏印', '偏印'),
    T('정인', 'Dir.Res.', '正印', '正印'),
  ];

  /// 원국에 있을 때의 의미.
  static const tenGodMeaning = [
    T('나와 같은 기운. 자립심과 주관이 뚜렷하고 친구·동료 운이 있어요. 경쟁심이 강해 고집으로 흐르지 않게 주의해요.',
      'Energy like your own. Independent and opinionated, with luck in friends and peers. Competitive—watch that it doesn\'t harden into stubbornness.',
      '自分と同じ気。自立心と主観が強く、友人・同僚運があります。競争心が強く頑固にならないよう注意。',
      '与我同气。独立、有主见，友人同伴运佳。竞争心强，注意别流于固执。'),
    T('나와 같은 오행, 다른 음양. 승부욕과 추진력이 강하지만 재물이 새기 쉬워요. 동업과 보증은 신중하게.',
      'Same element, opposite polarity. Strong drive and competitiveness, but money leaks easily. Be careful with partnerships and guarantees.',
      '同じ五行で陰陽が異なる。勝負欲と推進力が強い反面、財が漏れやすい。共同事業や保証は慎重に。',
      '同五行异阴阳。好胜心与推动力强，但钱财易漏。合伙与担保须谨慎。'),
    T('내가 낳는 기운. 여유와 복록, 먹을 복이 있고 표현이 부드러워요. 낙천적이며 재능을 자연스럽게 펼쳐요.',
      'Energy you create. Ease, blessings and the "luck of good food"; your expression is gentle. Optimistic, you unfold your talents naturally.',
      '自分が生み出す気。ゆとりと福禄、食の福があり表現が柔らか。楽天的で才能を自然に広げます。',
      '我生之气。有福禄与口福，表达温和。乐观，才华自然施展。'),
    T('내가 낳는 기운 중 활발한 쪽. 재치와 창의력, 언변이 뛰어나지만 규칙에 반발하기 쉬워요. 예술·기획에 강해요.',
      'The lively side of what you create. Wit, creativity and eloquence, but a tendency to rebel against rules. Strong in arts and planning.',
      '自分が生む気のうち活発な方。機知と創造力、弁舌に優れますが規則に反発しがち。芸術・企画に強い。',
      '我生之气中活跃的一面。机智、创意、口才出众，但易反抗规则。擅长艺术与策划。'),
    T('내가 다스리는 재물 중 움직이는 재물. 사업 감각과 씀씀이가 크고 사교적이에요. 큰돈이 들어오고 나가는 흐름이 있어요.',
      'Wealth you command that moves. Business sense, generous spending and sociability; large sums flow in and out.',
      '自分が支配する財のうち動く財。事業センスと気前が良く社交的。大きなお金の出入りがあります。',
      '我克之财中流动的财。有商业头脑、出手大方、善于社交。大钱进出的流动。'),
    T('내가 다스리는 안정된 재물. 성실하게 모으는 힘이 있고 계획적이에요. 배우자 운과 관련이 깊어요.',
      'Stable wealth you command. You save diligently and plan well. Closely tied to spouse luck.',
      '自分が支配する安定した財。堅実に蓄える力があり計画的。配偶者運と深く関係します。',
      '我克之稳定财富。踏实积累、有计划性。与配偶运关系密切。'),
    T('나를 다스리는 강한 힘. 카리스마와 위기 돌파력이 있지만 압박과 스트레스도 커요. 통제하면 큰 권위가 돼요.',
      'A strong force that governs you. Charisma and the power to break through crises, but also pressure and stress. Mastered, it becomes great authority.',
      '自分を制する強い力。カリスマと危機突破力がありますが、圧迫とストレスも大きい。制御できれば大きな権威に。',
      '克我的强力。有魅力与突破危机的能力，但压力也大。驾驭得当便成大权威。'),
    T('나를 다스리는 바른 힘. 책임감과 명예, 조직 안에서의 신뢰를 뜻해요. 규범을 지키며 안정적으로 성장해요.',
      'A proper force that governs you. Responsibility, honor and trust within organizations. You grow steadily by keeping the rules.',
      '自分を正しく制する力。責任感と名誉、組織内での信頼を意味します。規範を守り安定して成長します。',
      '正当地约束我的力量。代表责任感、名誉与组织中的信任。遵守规范、稳步成长。'),
    T('나를 낳는 기운 중 독특한 쪽. 직관과 특수한 재능, 종교·예술·기술 분야의 감각이 있어요. 외로움을 타기도 해요.',
      'The unusual side of what nourishes you. Intuition and special talents, a feel for religion, art or technology. You may feel lonely at times.',
      '自分を生む気のうち独特な方。直感と特殊な才能、宗教・芸術・技術のセンスがあります。孤独を感じることも。',
      '生我之气中独特的一面。有直觉与特殊才能，对宗教、艺术、技术有感觉。有时会感到孤独。'),
    T('나를 낳는 바른 기운. 학문과 문서, 어머니와 귀인의 도움을 뜻해요. 배우는 복이 있고 인품이 온화해요.',
      'The proper energy that nourishes you. Learning, documents, and help from mother and mentors. Blessed in study, gentle in character.',
      '自分を正しく生む気。学問と文書、母や貴人の助けを意味します。学ぶ福があり人柄が温和。',
      '正当地滋养我的气。代表学问、文书、母亲与贵人的帮助。有学习之福，人品温和。'),
  ];

  /// 오늘의 일진 천간이 이 십신일 때의 운세.
  static const dailyByGod = [
    T('나와 같은 기운이 들어오는 날. 자기 주장이 세지고 경쟁이 생겨요. 혼자 밀어붙이기보다 동료와 힘을 합치면 좋은 결과가 나요.',
      'A day when energy like yours arrives. You grow assertive and competition appears. Joining forces with peers beats pushing alone.',
      '自分と同じ気が入る日。主張が強まり競争が生まれます。一人で押すより仲間と力を合わせると良い結果に。',
      '与你同气的一天。主见变强、竞争出现。与同伴合力比独自硬推更有成果。'),
    T('재물이 새기 쉬운 날. 충동구매와 내기, 보증은 피하세요. 대신 운동이나 도전적인 일에 에너지를 쓰면 좋아요.',
      'Money leaks easily today. Avoid impulse buys, bets and guarantees. Put the energy into exercise or a bold task instead.',
      '財が漏れやすい日。衝動買いや賭け、保証は避けて。代わりに運動や挑戦にエネルギーを使うと吉。',
      '钱财易漏的一天。避免冲动消费、打赌和担保。把精力用在运动或挑战上更好。'),
    T('여유롭고 즐거운 날. 맛있는 음식과 좋은 대화가 따르고 아이디어가 술술 나와요. 창작이나 발표에 좋은 날이에요.',
      'A relaxed, pleasant day. Good food and conversation follow, and ideas flow. Great for creating or presenting.',
      'ゆとりと楽しさの日。おいしい食事と良い会話に恵まれ、アイデアが湧きます。創作や発表に良い日。',
      '悠闲愉快的一天。有美食与好谈话，灵感源源不断。适合创作或发表。'),
    T('말이 앞서기 쉬운 날. 재치는 빛나지만 윗사람과의 마찰을 조심하세요. 창의적인 일에 집중하면 에너지가 좋은 쪽으로 흘러요.',
      'Words may run ahead of you today. Your wit shines, but beware friction with superiors. Channel the energy into creative work.',
      '言葉が先走りやすい日。機知は光りますが目上との摩擦に注意。創造的な仕事に集中すると気が良い方向へ。',
      '话容易说过头的一天。才思闪光，但要小心与上级摩擦。专注创意工作，能量就会流向好的方向。'),
    T('돈과 사람이 움직이는 날. 뜻밖의 수입이나 만남이 생길 수 있어요. 씀씀이가 커지니 지갑 사정을 한 번 더 확인하세요.',
      'Money and people are on the move. Unexpected income or encounters may come. Spending grows, so check your wallet twice.',
      'お金と人が動く日。思わぬ収入や出会いがあるかも。出費が増えるので財布事情をもう一度確認を。',
      '钱与人流动的一天。可能有意外收入或相遇。花销变大，记得再看一眼钱包。'),
    T('성실함이 보상받는 날. 꾸준히 해온 일에서 결실이 보이고 금전 운이 안정적이에요. 연인이나 배우자와의 시간도 좋아요.',
      'Diligence pays off today. Steady work shows results and money luck is stable. Time with a partner or spouse goes well too.',
      '誠実さが報われる日。続けてきたことに実りが見え、金運が安定。恋人や配偶者との時間も良好。',
      '踏实得到回报的一天。坚持的事情见到成果，财运稳定。与伴侣相处的时光也很好。'),
    T('압박이 느껴지는 날. 갑작스러운 일이나 상사의 요구가 몰릴 수 있어요. 무리하지 말고 우선순위를 정해 하나씩 처리하면 오히려 실력을 인정받아요.',
      'Pressure builds today. Sudden tasks or demands from above may pile up. Don\'t overreach—set priorities and handle them one by one, and your ability gets recognized.',
      '圧迫を感じる日。急な用事や上司の要求が重なるかも。無理せず優先順位を決めて一つずつ処理すれば、むしろ実力が認められます。',
      '感到压力的一天。可能突然有事或上级要求集中。别勉强，排好优先级逐一处理，反而能获得认可。'),
    T('책임과 신뢰의 날. 약속을 지키고 규칙을 따르면 좋은 평가가 따라요. 계약이나 공적인 자리에 유리한 날이에요.',
      'A day of responsibility and trust. Keeping promises and rules brings good appraisal. Favorable for contracts and official occasions.',
      '責任と信頼の日。約束を守り規則に従えば良い評価が。契約や公的な場に有利な日。',
      '责任与信任的一天。守约守规会得到好评。有利于签约和正式场合。'),
    T('생각이 많아지는 날. 직관이 예리해지지만 혼자 골똘히 빠지기 쉬워요. 공부나 연구, 혼자 하는 작업에 집중하면 좋아요.',
      'A thoughtful day. Intuition sharpens, but you may sink into solitary brooding. Focus on study, research or solo work.',
      '考えが増える日。直感が鋭くなりますが一人で考え込みやすい。勉強や研究、一人作業に集中すると吉。',
      '思绪增多的一天。直觉敏锐，但容易独自沉思。专注于学习、研究或独立工作为佳。'),
    T('귀인이 돕는 날. 배움과 문서, 윗사람의 조언에서 좋은 기회가 와요. 마음이 안정되고 판단이 맑아지는 날이에요.',
      'Helpers appear today. Good opportunities come through learning, documents and advice from elders. Your mind is calm and judgment clear.',
      '貴人が助ける日。学びや文書、目上の助言から良い機会が。心が安定し判断が澄む日。',
      '贵人相助的一天。学习、文书和长辈的建议带来好机会。心境安定、判断清明。'),
  ];

  /// 십신별 기본 점수 (0~100).
  static const dailyBaseScore = [70, 58, 84, 62, 72, 80, 55, 82, 66, 86];

  /// 오늘 지지와 일지의 관계 한 줄.
  static const dailyByRelation = [
    T('', '', '', ''),
    T('오늘의 지지가 내 일지와 합(合)을 이뤄 사람 관계가 부드러워요.',
      'Today\'s branch harmonizes with your day branch—relationships flow smoothly.',
      '今日の地支が日支と合を成し、人間関係がなめらかです。',
      '今日地支与你的日支相合，人际关系顺畅。'),
    T('오늘의 지지가 내 일지와 삼합(三合)이라 뜻이 맞는 사람을 만나요.',
      'Today\'s branch forms a trine with your day branch—you meet like-minded people.',
      '今日の地支が日支と三合で、気の合う人に出会えます。',
      '今日地支与你的日支三合，会遇到志同道合的人。'),
    T('오늘의 지지가 내 일지와 충(沖)이라 변동이 있어요. 이동·계약은 한 번 더 확인하세요.',
      'Today\'s branch clashes with your day branch—expect changes. Double-check travel and contracts.',
      '今日の地支が日支と沖で変動あり。移動・契約はもう一度確認を。',
      '今日地支与你的日支相冲，会有变动。出行、签约请再确认。'),
  ];

  static const relationScore = [0, 10, 8, -12];
}
