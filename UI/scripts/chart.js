$(document).ready(function() {
    var html = "";
    for (var i = 0; i < total_line; i++) {
        var type_class = 'basic';
        if (i >= youon_line[0]) { type_class = 'youon'; }
        else if (i >= dakuten_line[0]) { type_class = 'dakuten'; }

        html += '<li class="clearfix ' + type_class + '">';

        // line head
        var head_view = {
            kana_char: hs[i * 5],
            kana_alpha: ls[i * 5]
        };
        html += Mustache.render('\
        <div class="head">\
            <p class="kana">{{ kana_char }}</p>\
            <p class="romaji">{{ kana_alpha }}</p>\
        </div>', head_view);

        for (var j = 0; j < 5; j++) {
            var kana_id = i * 5 + j;

            if (hs[kana_id] === "") {
                continue;
            }

            var item_view = {
                dup: function() {
                    return hs[kana_id][0] == '(';
                },
                hiragana: function() {
                    if (hs[kana_id][0] == '(') {
                        return hs[kana_id].slice(1, -1);
                    }
                    return hs[kana_id];
                },
                katakana: function() {
                    if (ks[kana_id][0] == '(') {
                        return ks[kana_id].slice(1, -1);
                    }
                    return ks[kana_id];
                },
                latin: function() {
                    if (ls[kana_id][0] == '(') {
                        return ls[kana_id].slice(1, -1);
                    }
                    return ls[kana_id];
                }
            };
            html += Mustache.render('<div class="item{{#dup}} dup{{/dup}}">\
                <p class="kana">{{ hiragana }}</p>\
                <p class="kana">{{ katakana }}</p>\
                <p class="romaji">{{ latin }}</p>\
            </div>', item_view);
        }
        html += '</li>';
    }
    $("#kana-chart").append(html);
});