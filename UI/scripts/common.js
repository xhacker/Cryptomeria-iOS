total_line = 26;
section = [0, 11, 16, 26];
basic_line = [0, 10]; // including n/m
dakuten_line = [11, 15]; // including handakuten
youon_line = [16, 25];

function get_section_range_by_id(id) {
    var range = {
        "start": 0,
        "end": 0
    }
    for (var i in section) {
        if (id < section[parseInt(i) + 1] * 5) {
            range.start = section[i] * 5;
            range.end = section[parseInt(i) + 1] * 5 - 1;
            return range;
        }
    }
}

ls = [
    'a',   'i',   'u',   'e',   'o',
    'ka',  'ki',  'ku',  'ke',  'ko',
    'sa',  'shi', 'su',  'se',  'so',
    'ta',  'chi', 'tsu', 'te',  'to',
    'na',  'ni',  'nu',  'ne',  'no',
    'ha',  'hi',  'fu',  'he',  'ho',
    'ma',  'mi',  'mu',  'me',  'mo',
    'ya',  '(i)', 'yu',  '(e)', 'yo',
    'ra',  'ri',  'ru',  're',  'ro',
    'wa',  '(i)', '(u)', '(e)', 'wo',
    'n/m',  '',   '',    '',    '',
    'ga',  'gi',  'gu',  'ge',  'go',
    'za',  'ji',  'zu',  'ze',  'zo',
    'da',  'ji',  'zu',  'de',  'do',
    'ba',  'bi',  'bu',  'be',  'bo',
    'pa',  'pi',  'pu',  'pe',  'po',
    'kya', 'kyu', 'kyo', '',    '',
    'gya', 'gyu', 'gyo', '',    '',
    'sha', 'shu', 'sho', '',    '',
    'ja',  'ju',  'jo',  '',    '',
    'cha', 'chu', 'cho', '',    '',
    'nya', 'nyu', 'nyo', '',    '',
    'hya', 'hyu', 'hyo', '',    '',
    'bya', 'byu', 'byo', '',    '',
    'pya', 'pyu', 'pyo', '',    '',
    'mya', 'myu', 'myo', '',    ''
];

hs = [
    'あ',  'い',  'う',  'え',  'お',
    'か',  'き',  'く',  'け',  'こ',
    'さ',  'し',  'す',  'せ',  'そ',
    'た',  'ち',  'つ',  'て',  'と',
    'な',  'に',  'ぬ',  'ね',  'の',
    'は',  'ひ',  'ふ',  'へ',  'ほ',
    'ま',  'み',  'む',  'め',  'も',
    'や',  '(い)','ゆ',  '(え)','よ',
    'ら',  'り',  'る',  'れ',  'ろ',
    'わ',  '(い)','(う)','(え)','を',
    'ん',  '',  '',  '',  '',
    'が',  'ぎ',  'ぐ',  'げ',  'ご',
    'ざ',  'じ',  'ず',  'ぜ',  'ぞ',
    'だ',  'ぢ',  'づ',  'で',  'ど',
    'ば',  'び',  'ぶ',  'べ',  'ぼ',
    'ぱ',  'ぴ',  'ぷ',  'ぺ',  'ぽ',
    'きゃ', 'きゅ', 'きょ',  '',  '',
    'ぎゃ', 'ぎゅ', 'ぎょ',  '',  '',
    'しゃ', 'しゅ', 'しょ',  '',  '',
    'じゃ', 'じゅ', 'じょ',  '',  '',
    'ちゃ', 'ちゅ', 'ちょ',  '',  '',
    'にゃ', 'にゅ', 'にょ',  '',  '',
    'ひゃ', 'ひゅ', 'ひょ',  '',  '',
    'びゃ', 'びゅ', 'びょ',  '',  '',
    'ぴゃ', 'ぴゅ', 'ぴょ',  '',  '',
    'みゃ', 'みゅ', 'みょ',  '',  ''
];

ks = [
    'ア',  'イ',  'ウ',  'エ',  'オ',
    'カ',  'キ',  'ク',  'ケ',  'コ',
    'サ',  'シ',  'ス',  'セ',  'ソ',
    'タ',  'チ',  'ツ',  'テ',  'ト',
    'ナ',  'ニ',  'ヌ',  'ネ',  'ノ',
    'ハ',  'ヒ',  'フ',  'ヘ',  'ホ',
    'マ',  'ミ',  'ム',  'メ',  'モ',
    'ヤ',  '(イ)','ユ',  '(エ)','ヨ',
    'ラ',  'リ',  'ル',  'レ',  'ロ',
    'ワ',  '(イ)','(ウ)','(エ)','ヲ',
    'ン',  '',  '',  '',  '',
    'ガ',  'ギ',  'グ',  'ゲ',  'ゴ',
    'ザ',  'ジ',  'ズ',  'ゼ',  'ゾ',
    'ダ',  'ヂ',  'ヅ',  'デ',  'ド',
    'バ',  'ビ',  'ブ',  'ベ',  'ボ',
    'パ',  'ピ',  'プ',  'ペ',  'ポ',
    'キャ', 'キュ', 'キョ',  '',  '',
    'ギャ', 'ギュ', 'ギョ',  '',  '',
    'シャ', 'シュ', 'ショ',  '',  '',
    'ジャ', 'ジュ', 'ジョ',  '',  '',
    'チャ', 'チュ', 'チョ',  '',  '',
    'ニャ', 'ニュ', 'ニョ',  '',  '',
    'ヒャ', 'ヒュ', 'ヒョ',  '',  '',
    'ビャ', 'ビュ', 'ビョ',  '',  '',
    'ピャ', 'ピュ', 'ピョ',  '',  '',
    'ミャ', 'ミュ', 'ミョ',  '',  ''
];

vs = [
    [
        // a
        {"kana":"あい", "meaning":"love"},
        {"kana":"いう", "meaning":"say"},
        {"kana":"うえ", "meaning":"up"},
        {"kana":"うお", "meaning":"fish"},
        {"kana":"おう", "meaning":"owe"},
        {"kana":"あう", "meaning":"meet"},
        {"kana":"おい", "meaning":"nephew"},
        {"kana":"おおい", "meaning":"many"},
        {"kana":"いい", "meaning":"good"},
        {"kana":"あおい", "meaning":"blue"},
        {"kana":"いえ", "meaning":"home"},
        {"kana":"いいえ", "meaning":"no"},
        {"kana":"エア", "meaning":"air"}
    ],
    [
        // ka
        {"kana":"いか", "meaning":"squid"},
        {"kana":"かう", "meaning":"buy"},
        {"kana":"おく", "meaning":"place"},
        {"kana":"ここ", "meaning":"here"},
        {"kana":"きかい", "meaning":"opportunity"},
        {"kana":"きこく", "meaning":"return"},
        {"kana":"かかく", "meaning":"price"},
        {"kana":"かお", "meaning":"face"},
        {"kana":"きく", "meaning":"listen"},
        {"kana":"きおく", "meaning":"memory"},
        {"kana":"くけい", "meaning":"rectangle"},
        {"kana":"くう", "meaning":"eat"},
        {"kana":"くい", "meaning":"regret"},
        {"kana":"いく", "meaning":"go"},
        {"kana":"ココア", "meaning":"cocoa"},
        {"kana":"けいき", "meaning":"economy"},
        {"kana":"こえ", "meaning":"sound"},
        {"kana":"こい", "meaning":"carp"}
    ],
    [
        // sa
        {"kana":"あさ", "meaning":"morning"},
        {"kana":"そこく", "meaning":"homeland"},
        {"kana":"すいか", "meaning":"watermelon"},
        {"kana":"せかい", "meaning":"world"},
        {"kana":"しあい", "meaning":"game"},
        {"kana":"しお", "meaning":"salt"},
        {"kana":"アイス", "meaning":"ice"},
        {"kana":"きせき", "meaning":"miracle"},
        {"kana":"あさい", "meaning":"shallow"},
        {"kana":"きそ", "meaning":"basis"},
        {"kana":"あす", "meaning":"tomorrow"},
        {"kana":"しき", "meaning":"four seasons"},
        {"kana":"あし", "meaning":"foot"}
    ],
    [
        // ta
        {"kana":"おたく", "meaning":"home"},
        {"kana":"ちかてつ", "meaning":"subway"},
        {"kana":"たたかう", "meaning":"fight"},
        {"kana":"きたい", "meaning":"expect"},
        {"kana":"とけい", "meaning":"watch"},
        {"kana":"ちかく", "meaning":"near"},
        {"kana":"ちしき", "meaning":"knowledge"},
        {"kana":"あいて", "meaning":"opponent"},
        {"kana":"てあし", "meaning":"hands and feet"},
        {"kana":"あと", "meaning":"later"},
        {"kana":"いたい", "meaning":"painful"},
        {"kana":"とち", "meaning":"land"},
        {"kana":"いと", "meaning":"intent"},
        {"kana":"ちかう", "meaning":"pledge"}
    ],
    [
        // na
        {"kana":"かない", "meaning":"wife"},
        {"kana":"なに", "meaning":"what"},
        {"kana":"ねこ", "meaning":"cat"},
        {"kana":"ぬの", "meaning":"cloth"},
        {"kana":"あなた", "meaning":"you"},
        {"kana":"のこす", "meaning":"leave"},
        {"kana":"にあう", "meaning":"match"},
        {"kana":"きぬ", "meaning":"silk"},
        {"kana":"きたない", "meaning":"dirty"},
        {"kana":"きのう", "meaning":"yesterday"},
        {"kana":"さかな", "meaning":"fish"},
        {"kana":"なく", "meaning":"cry"},
        {"kana":"にく", "meaning":"meat"},
        {"kana":"いぬ", "meaning":"dog"},
        {"kana":"くに", "meaning":"country"},
        {"kana":"ぬく", "meaning":"pull"},
        {"kana":"きのこ", "meaning":"mushroom"}
    ],
    [
        // ha
        {"kana":"はい", "meaning":"yes"}, 
        {"kana":"はこ", "meaning":"box"},
        {"kana":"ひふ", "meaning":"skin"},
        {"kana":"ほそい", "meaning":"thin"},
        {"kana":"へいたい", "meaning":"soldier"},
        {"kana":"ふかい", "meaning":"deep"},
        {"kana":"ひくい", "meaning":"low"},
        {"kana":"ひかく", "meaning":"comparison"},
        {"kana":"はち", "meaning":"bee"},
        {"kana":"ひにち", "meaning":"daily"},
        {"kana":"きはく", "meaning":"spirit"},
        {"kana":"ひにく", "meaning":"irony"},
        {"kana":"へいき", "meaning":"weapon"},
        {"kana":"ほかの", "meaning":"other"},
        {"kana":"ひと", "meaning":"people"},
        {"kana":"ほす", "meaning":"dry"},
        {"kana":"ひとこと", "meaning":"word"},
        {"kana":"はくし", "meaning":"blank"},
        {"kana":"はついく", "meaning":"development"},
        {"kana":"はかせ", "meaning":"doctor"},
        {"kana":"ひこうき", "meaning":"airplane"},
        {"kana":"ひさしい", "meaning":"long"},
        {"kana":"ふくし", "meaning":"Fukushima"}
    ],
    [
        // ma
        {"kana":"もも", "meaning":"peach"},
        {"kana":"むし", "meaning":"insect"},
        {"kana":"まめ", "meaning":"beans"},
        {"kana":"むすめ", "meaning":"daughter"},
        {"kana":"かみさま", "meaning":"god"},
        {"kana":"まいにち", "meaning":"every day"},
        {"kana":"きみ", "meaning":"kid"},
        {"kana":"さむい", "meaning":"cold"},
        {"kana":"もの", "meaning":"thing"},
        {"kana":"むすこ", "meaning":"son"},
        {"kana":"すまない", "meaning":"sorry"},
        {"kana":"もくてき", "meaning":"purpose"},
        {"kana":"めめしい", "meaning":"pussy"},
        {"kana":"ひみつ", "meaning":"secret"}
    ],
    [
        // ya
        {"kana":"やま", "meaning":"mountain"},
        {"kana":"やおや", "meaning":"greengrocer"},
        {"kana":"よやく", "meaning":"reservation"},
        {"kana":"やみよ", "meaning":"dark night"},
        {"kana":"おゆ", "meaning":"hot water"},
        {"kana":"よく", "meaning":"well"},
        {"kana":"やさい", "meaning":"vegetable"},
        {"kana":"やすい", "meaning":"cheap"},
        {"kana":"ひやく", "meaning":"jump"},
        {"kana":"もやし", "meaning":"bean sprout"},
        {"kana":"もよおす", "meaning":"hold"},
        {"kana":"ゆかた", "meaning":"yukata"},
        {"kana":"ゆたか", "meaning":"rich"},
        {"kana":"おかゆ", "meaning":"rice porridge"},
        {"kana":"やさしい", "meaning":"easy"},
        {"kana":"やすみ", "meaning":"break"},
        {"kana":"ゆうやけ", "meaning":"sunset"},
        {"kana":"よこむき", "meaning":"sideway"},
        {"kana":"よくない", "meaning":"bad"},
        {"kana":"よのなか", "meaning":"world"}
    ],
    [
        // ra
        {"kana":"はる", "meaning":"spring"},
        {"kana":"れきし", "meaning":"history"},
        {"kana":"おふろ", "meaning":"bath"},
        {"kana":"きらい", "meaning":"hate"},
        {"kana":"たりる", "meaning":"sufficient"},
        {"kana":"るす", "meaning":"absence"},
        {"kana":"くもる", "meaning":"cloudy"},
        {"kana":"やるき", "meaning":"motivation"},
        {"kana":"おさら", "meaning":"dish"},
        {"kana":"ろうそく", "meaning":"candle"},
        {"kana":"しつれい", "meaning":"rude"},
        {"kana":"きれい", "meaning":"pretty"},
        {"kana":"ふろしき", "meaning":"wrapping cloth"},
        {"kana":"おもしろい", "meaning":"funny"},
        {"kana":"ひれつ", "meaning":"despicable"},
        {"kana":"あつまる", "meaning":"gather"},
        {"kana":"ならう", "meaning":"learn"},
        {"kana":"ふるい", "meaning":"old"},
        {"kana":"ふりかえる", "meaning":"look back"},
        {"kana":"きらく", "meaning":"comfortable"}
    ],
    [
        // wa
        {"kana":"わたし", "meaning":"I"},
        {"kana":"かわ", "meaning":"river"},
        {"kana":"すわる", "meaning":"sit"},
        {"kana":"わらう", "meaning":"laugh"},
        {"kana":"しあわせ", "meaning":"happiness"},
        {"kana":"きわめて", "meaning":"very"},
        {"kana":"わすれる", "meaning":"forget"},
        {"kana":"わかす", "meaning":"boil"},
        {"kana":"おせわ", "meaning":"care"},
        {"kana":"まわる", "meaning":"around"},
        {"kana":"わける", "meaning":"divide"},
        {"kana":"やわらかい", "meaning":"soft"},
        {"kana":"くわえる", "meaning":"add"},
        {"kana":"いわう", "meaning":"celebrate"},
        {"kana":"あらわす", "meaning":"represent"},
        {"kana":"わふく", "meaning":"Japanese clothes"},
        {"kana":"さわる", "meaning":"touch"}
    ]
];

function romanize(kana) {
    var index = hs.indexOf(kana);
    if (index >= 0) {
        return ls[index];
    }
    else {
        index = ks.indexOf(kana);
        return ls[index];
    }
}

function romanize_word(word) {
    var latin = "";
    for (var i = 0; i < word.length; i++) {
        latin += romanize(word[i]) + " ";
    }
    return latin;
}

for (var row in vs) {
    for (var v in vs[row]) {
        vs[row][v].latin = romanize_word(vs[row][v].kana);
    }
}