local L = KuiNameplatesCoreConfig:Locale('zhTW')
if not L then return end

L["page_names"] = {
	["auras"] = "光環",
	["bossmod"] = "首領模組",
	["castbars"] = "施法條",
	["classpowers"] = "職業資源",
	["framesizes"] = "框架尺寸",
	["general"] = "一般",
	["healthbars"] = "血條",
	["nameonly"] = "名字模式",
	["text"] = "文字",
	["threat"] = "威脅",
}

L["titles"] = {
	["absorb_enable"] = "顯示吸收",
	["absorb_striped"] = "條紋吸收材質",
	["auras_centre"] = "置中對齊圖示",
	["auras_enabled"] = "啟用",
	["auras_filtering_sep"] = "過濾",
	["auras_hide_all_other"] = "隱藏他人施放的所有光環",
	["auras_icon_minus_size"] = "圖示尺寸(次要)",
	["auras_icon_normal_size"] = "圖示尺寸(標準)",
	["auras_icon_squareness"] = "長寬比例",
	["auras_icons_sep"] = "圖示",
	["auras_kslc_hint"] = "KuiSpellListConfig（可在Curse上取得）可以讓你編輯法術黑名單和白名單，任何單位所施放的法術都可以放入自訂清單。",
	["auras_maximum_length"] = "最大顯示秒數",
	["auras_minimum_length"] = "最小顯示秒數",
	["auras_on_personal"] = "在個人資源上顯示",
	["auras_pulsate"] = "閃爍圖示",
	["auras_show_all_self"] = "顯示自身施放的所有光環",
	["auras_sort"] = "排序方式",
	["auras_time_threshold"] = "計時器閾值",
	["bar_animation"] = "血條動畫",
	["bar_texture"] = "血條材質",
	["bossmod_clickthrough"] = "名條自動顯示時啟用點擊穿透",
	["bossmod_control_visibility"] = "允許首領警報插件控制友方名條的能見度",
	["bossmod_enable"] = "啟用首領警報交互模組",
	["bossmod_icon_size"] = "圖示大小",
	["bossmod_x_offset"] = "水平位置",
	["bossmod_y_offset"] = "垂直位置",
	["bot_vertical_offset"] = "等級血量垂直偏移",
	["castbar_colour"] = "施法條顏色",
	["castbar_enable"] = "啟用",
	["castbar_height"] = "施法條高度",
	["castbar_icon"] = "顯示法術圖示",
	["castbar_name"] = "顯示法術名稱",
	["castbar_shield"] = "顯示盾牌圖示",
	["castbar_showall"] = "顯示所有單位的施法條",
	["castbar_showenemy"] = "顯示敵方施法條",
	["castbar_showfriend"] = "顯示友方施法條",
	["castbar_showpersonal"] = "顯示自身施法條",
	["castbar_unin_colour"] = "打斷免疫顏色",
	["class_colour_enemy_names"] = "敵方姓名職業著色",
	["class_colour_friendly_names"] = "友方姓名職業著色",
	["classpowers_bar_height"] = "資源條高度",
	["classpowers_bar_width"] = "資源條寬度",
	["classpowers_colour"] = "圖示顏色",
	["classpowers_colour_inactive"] = "閒置狀態",
	["classpowers_colour_overflow"] = "資源溢出",
	["classpowers_enable"] = "啟用",
	["classpowers_on_target"] = "顯示於目標",
	["classpowers_size"] = "圖示大小",
	["clickthrough_enemy"] = "敵方",
	["clickthrough_friend"] = "友方",
	["clickthrough_self"] = "個人",
	["clickthrough_sep"] = "點擊穿透",
	["colour_absorb"] = "吸收塗層",
	["colour_enemy_class"] = "敵方玩家職業著色",
	["colour_enemy_pet"] = "寵物",
	["colour_enemy_player"] = "玩家",
	["colour_friendly"] = "友善",
	["colour_friendly_pet"] = "寵物",
	["colour_hated"] = "敵對",
	["colour_neutral"] = "中立",
	["colour_player"] = "玩家",
	["colour_player_class"] = "友方玩家職業著色",
	["colour_self"] = "自己",
	["colour_self_class"] = "自身職業著色",
	["colour_tapped"] = "無拾取權",
	["combat_friendly"] = "戰鬥動作：友方",
	["combat_hostile"] = "戰鬥動作：敵方",
	["copy_profile_label"] = "鍵入新設定檔的名稱",
	["copy_profile_title"] = "複製設定檔",
	["dd_auras_sort_index"] = "光環索引",
	["dd_auras_sort_time"] = "剩餘時間",
	["dd_bar_animation_cutaway"] = "切除",
	["dd_bar_animation_smooth"] = "平滑",
	["dd_combat_toggle_hide"] = "戰鬥隱藏，脫戰顯示",
	["dd_combat_toggle_nothing"] = "不做什麼",
	["dd_combat_toggle_show"] = "戰鬥顯示，脫戰隱藏",
	["dd_font_style_monochrome"] = "點陣字描邊",
	["dd_font_style_none"] = "無",
	["dd_font_style_outline"] = "描邊",
	["dd_font_style_shadow"] = "陰影",
	["dd_font_style_shadowandoutline"] = "陰影+描邊",
	["dd_health_text_blank"] = "空白",
	["dd_health_text_current"] = "當前值",
	["dd_health_text_deficit"] = "損失值",
	["dd_health_text_maximum"] = "最大值",
	["dd_health_text_percent"] = "百分比",
	["delete_profile_label"] = "刪除設定檔 |cffffffff%s|r?",
	["delete_profile_title"] = "刪除設定檔",
	["execute_auto"] = "自動偵測斬殺血量",
	["execute_colour"] = "斬殺著色",
	["execute_enabled"] = "啟用斬殺著色",
	["execute_percent"] = "斬殺閾值",
	["execute_sep"] = "斬殺階段",
	["fade_all"] = "預設淡出",
	["fade_alpha"] = "淡出透明度",
	["fade_avoid_execute_friend"] = "避開低血量友方",
	["fade_avoid_execute_hostile"] = "避開低血量敵方",
	["fade_avoid_nameonly"] = "避開名字模式",
	["fade_avoid_raidicon"] = "避開團隊標記",
	["fade_avoid_tracked"] = "避開已追蹤或戰鬥中",
	["fade_friendly_npc"] = "淡出友方NPC",
	["fade_neutral_enemy"] = "淡出中立單位",
	["fade_rules_sep"] = "框架淡出",
	["fade_speed"] = "淡出動畫速度",
	["fade_untracked"] = "淡出非追蹤單位",
	["font_face"] = "文字字型",
	["font_size_normal"] = "一般字型大小",
	["font_size_small"] = "小字型大小",
	["font_style"] = "文字樣式",
	["frame_glow_size"] = "光暈尺寸",
	["frame_glow_threat"] = "顯示威脅光暈",
	["frame_height"] = "框架高度",
	["frame_height_minus"] = "次要單位高度",
	["frame_height_personal"] = "個人資源高度",
	["frame_width"] = "框架寬度",
	["frame_width_minus"] = "次要單位寬度",
	["frame_width_personal"] = "個人資源寬度",
	["glow_as_shadow"] = "顯示陰影光暈",
	["guild_text_npcs"] = "顯示NPC頭銜",
	["guild_text_players"] = "顯示玩家公會",
	["health_text"] = "顯示血量",
	["health_text_friend_dmg"] = "損血友方",
	["health_text_friend_max"] = "滿血友方",
	["health_text_hostile_dmg"] = "損血敵方",
	["health_text_hostile_max"] = "滿血敵方",
	["health_text_sep"] = "血量文字",
	["hide_names"] = "隱藏非追蹤單位名稱",
	["ignore_uiscale"] = "忽略介面縮放",
	["level_text"] = "顯示等級",
	["name_text"] = "顯示名稱",
	["name_vertical_offset"] = "名字垂直偏移",
	["nameonly"] = "啟用名字模式",
	["nameonly_all_enemies"] = "使用在敵對",
	["nameonly_damaged_friends"] = "在受損傷的友方",
	["nameonly_enemies"] = "在不可攻擊的敵人",
	["nameonly_health_colour"] = "血量著色",
	["nameonly_in_combat"] = "正在交戰的單位",
	["nameonly_neutral"] = "在中立單位",
	["nameonly_no_font_style"] = "無字型描邊",
	["nameonly_on_default"] = "暴雪名條名字模式",
	["nameonly_target"] = "使用在目標",
	["new_profile"] = "新設定檔...",
	["new_profile_label"] = "輸入設定檔名稱",
	["powerbar_height"] = "能量條高度",
	["profile"] = "設定檔",
	["reaction_colour_sep"] = "血量條顏色",
	["rename_profile_label"] = "將|cffffffff%s重新命名",
	["rename_profile_title"] = "重新命名設定檔",
	["reset_profile_label"] = "重置設定檔|cffffffff%s|r？",
	["reset_profile_title"] = "重置設定檔",
	["state_icons"] = "顯示狀態圖示",
	["tank_mode"] = "啟用",
	["tankmode_colour_sep"] = "血條顏色",
	["tankmode_force_enable"] = "強制坦克模式",
	["tankmode_force_offtank"] = "強制換坦偵測",
	["tankmode_other_colour"] = "副坦第二仇恨",
	["tankmode_tank_colour"] = "當前坦仇恨穩定",
	["tankmode_trans_colour"] = "仇恨轉移",
	["target_arrows"] = "顯示目標箭頭",
	["target_arrows_size"] = "箭頭尺寸",
	["target_glow"] = "顯示目標光暈",
	["target_glow_colour"] = "目標光暈顏色",
	["text_vertical_offset"] = "文字垂直偏移",
	["threat_brackets"] = "顯示威脅括號",
	["title_text_players"] = "顯示玩家頭銜",
	["use_blizzard_personal"] = "忽略個人資源",
	["version"] = "%s 作者: %s @ Curse, 版本 %s",
}

L["tooltips"] = {
	["absorb_enable"] = "在血條上顯示吸收盾",
	["absorb_striped"] = "在吸收盾上使用條紋材質。如果未勾選，繼承血條材質。",
	["auras_centre"] = "水平置中對齊框架上的圖示，而非靠左對齊",
	["auras_enabled"] = "在名條上顯示你施放的光環：友方顯示增益，敵方顯示減益",
	["auras_hide_all_other"] = "不顯示任何他人施放的光環（如控場和緩速）。|n|n請注意：KuiSpellList的生效優先級高於此選項，所以你仍然可以在勾選此選項的情況下用|cffffff88KuiSpellListConfig|r（可在Curse上取得）自訂特定法術的顯示。",
	["auras_icon_minus_size"] = "次要單位名條的圖示大小",
	["auras_icon_normal_size"] = "標準單位名條的圖示大小",
	["auras_icon_squareness"] = "光環圖示的長寬比例，設為1代表正方形",
	["auras_maximum_length"] = "不顯示秒數大於此數值的光環。將值設為-1可忽略此選項",
	["auras_minimum_length"] = "不顯示秒數低於此數值的光環",
	["auras_on_personal"] = "如果啟用，在個人資源上顯示你的光環",
	["auras_pulsate"] = "快要結束時閃爍圖標",
	["auras_show_all_self"] = "顯示你施放的所有光環，而非只顯示暴雪預設的重要光環。|n|n請注意：KuiSpellList的生效優先級高於此選項，所以你仍然可以在勾選此選項的情況下用|cffffff88KuiSpellListConfig|r（可在Curse上取得）自訂特定法術的顯示。",
	["auras_time_threshold"] = "當光環的剩餘秒數少於這個數值時，顯示倒數文字。設為-1可使倒數計時總是顯示",
	["bar_animation"] = "血量／能量條變化的動畫方式",
	["bar_texture"] = "狀態條使用的材質（由LibSharedMedia提供）",
	["bossmod_clickthrough"] = "當友方血條自動顯示的時候禁用點擊",
	["bossmod_control_visibility"] = "首領警報插件可以發送訊息給名條插件，通知他們在首領戰中保持啟用友方名條；並忽略其他設定（如自動戰鬥切換）以便在友方玩家身上顯示額外的訊息。|n|n|cffff6666如果禁用此選項、且沒有啟用友方名條，首領警報模組將無法顯示資訊。",
	["bossmod_enable"] = "首領警報插件可以與名條插件聯動，在相關首領戰中於名條上顯示額外訊息；例如首領施放的重要增減益效果。",
	["bossmod_icon_size"] = "首領光環圖示大小",
	["bossmod_x_offset"] = "首領光環圖示位置的水平偏移量",
	["bossmod_y_offset"] = "首領光環圖示位置的垂直偏移量",
	["bot_vertical_offset"] = "等級血量位置的垂直偏移量",
	["castbar_enable"] = "啟用施法條",
	["castbar_shield"] = "在免疫打斷的施法條上顯示盾牌圖示",
	["castbar_showall"] = "在所有名條上顯示施法條",
	["castbar_showenemy"] = "顯用敵方施法條",
	["castbar_showfriend"] = "顯示友方施法條，注意：啟用名字模式時不會顯示施法條",
	["castbar_showpersonal"] = "如果啟用個人資源，在其上顯示自身施法條",
	["castbar_unin_colour"] = "著色無法被打斷的施法條",
	["class_colour_enemy_names"] = "根據職業著色敵方玩家名字。此選項同時也作用於名字模式的文字文本。",
	["class_colour_friendly_names"] = "根據職業著色友方玩家名字。此選項同時也作用於名字模式的文字文本。",
	["classpowers_bar_height"] = "醉仙緩勁條高度",
	["classpowers_bar_width"] = "醉仙緩勁條寬度",
	["classpowers_colour"] = "職業副資源（如連擊點、聖能）的顏色",
	["classpowers_colour_inactive"] = "職業能量靜止時的圖示顏色",
	["classpowers_colour_overflow"] = "職業能量「溢出」的顏色（類似盜賊的預知）",
	["classpowers_enable"] = "顯示副資源，像是連擊點、聖能等等。",
	["classpowers_on_target"] = "將副資源顯示於目標，而非依附個人資源",
	["classpowers_size"] = "副資源圖示尺寸",
	["clickthrough_enemy"] = "禁止點擊個人資源",
	["clickthrough_friend"] = "禁止點擊友方名條",
	["clickthrough_self"] = "禁止點擊個人資源",
	["colour_friendly_pet"] = "請注意：友方玩家寵物一般不會顯示名條",
	["colour_player"] = "其他友方玩家名條的顏色",
	["colour_self"] = "個人資源的血條顏色",
	["colour_self_class"] = "以職業顏色著色個人資源",
	["combat_friendly"] = "進入與離開戰鬥時在友方框架上採取的動作。",
	["combat_hostile"] = "進入與離開戰鬥時在敵方框架上採取的動作。",
	["execute_auto"] = "自動偵測你的天賦專精所需的斬殺閾值，對於無斬殺的角色預設為20%",
	["execute_colour"] = "斬殺階段使用的顏色",
	["execute_enabled"] = "當單位進入斬殺階段時，重新著色血條",
	["execute_percent"] = "手動設定斬殺階段血量閾值",
	["fade_all"] = "預設狀態下淡出所有框架",
	["fade_alpha"] = "淡出框架的透明度。請注意：如果設為0（即框架不可見），不可見的名條仍然可以點擊。插件不能任意禁用名條的點擊框。",
	["fade_avoid_execute_friend"] = "不要淡出血量處於斬殺階段的友方名條（在「血量條」頁面設置）",
	["fade_avoid_execute_hostile"] = "不要淡出血量處於斬殺階段的敵方名條（在「血量條」頁面設置）",
	["fade_avoid_nameonly"] = "啟用名字模式時，不要淡出名條",
	["fade_avoid_raidicon"] = "不要淡出被標記了團隊圖示的名條",
	["fade_avoid_tracked"] = "不淡出已追蹤或是正在與你戰鬥中的單位名條。|n透過改變 Esc > 介面 > 名稱 > 「NPC名稱」的選項來設定是否進行追蹤。",
	["fade_friendly_npc"] = "預設淡出友方NPC名條（包含名字模式）",
	["fade_neutral_enemy"] = "預設淡出可攻擊的中立單位名條（包含名字模式）",
	["fade_speed"] = "框架淡出的速度，1是最慢的，0是立刻淡出",
	["fade_untracked"] = "淡出非追蹤名條（包含名字模式）。|n透過改變 Esc > 介面 > 名稱中的「NPC名稱」的選項來設定是否進行追蹤",
	["font_face"] = "名條所使用的全局字型（由LibSharedMedia提供）",
	["font_size_normal"] = "標準字型大小 （名稱等）",
	["font_size_small"] = "小字型大小（商人、法術名稱等等）",
	["frame_glow_size"] = "目標高亮與威脅指示的光暈尺寸",
	["frame_glow_threat"] = "以光暈的顏色變化來指示威脅狀態",
	["frame_height"] = "標準名條高度",
	["frame_height_minus"] = "次要敵方單位和無名字（不重要的單位）的名條高度（次要敵人一般會顯示比較小的名條）",
	["frame_height_personal"] = "個人資源條的高度（若要啟用，勾選 Esc > 介面 > 名稱 > 顯示個人資源）",
	["frame_width"] = "標準名條寬度",
	["frame_width_minus"] = "次要敵方單位的名條寬度（次要敵人一般會顯示比較小的名條）",
	["frame_width_personal"] = "個人資源條的寬度（若要啟用，勾選 Esc > 介面 > 名稱 > 顯示個人資源）",
	["guild_text_npcs"] = "顯示NPC的頭銜，像是軍需官...等等。",
	["guild_text_players"] = "啟用名字模式時，顯示玩家公會",
	["health_text_friend_dmg"] = "友方玩家損血時的血量文字格式",
	["health_text_friend_max"] = "友方玩家滿血時的血量文字格式",
	["health_text_hostile_dmg"] = "敵方玩家損血時的血量文字格式",
	["health_text_hostile_max"] = "敵方玩家滿血時的血量文字格式",
	["hide_names"] = "你可以透過改變 Esc > 介面 > 名稱 > 「NPC名稱」的選項來設定是否進行追蹤。注意：此設定在名字模式不生效",
	["ignore_uiscale"] = "忽略預設的介面縮放。這可以讓名條維持精確的像素，不受解析度影響。",
	["name_vertical_offset"] = "名字文字位置的垂直偏移量",
	["nameonly"] = "隱藏友方或不可攻擊單位的血條。啟用此模組時以血量百分比著色名字。",
	["nameonly_all_enemies"] = "在所有敵方單位使用名字模式",
	["nameonly_damaged_friends"] = "在所有友方單位使用名字模式，即使血量未滿",
	["nameonly_enemies"] = "在不可攻擊的敵方單位使用名字模式（不包括在免疫狀態下的敵方玩家）",
	["nameonly_health_colour"] = "以部份著色的方式來顯示血量百分比",
	["nameonly_in_combat"] = "啟用此選項，會強制使用名字模式，即便該單位正在與你戰鬥。|n|n注意，這也作用於敵方玩家單位，但不適用於訓練假人或其他沒有威脅值列表的單位。",
	["nameonly_neutral"] = "在可攻擊的中立單位使用名字模式",
	["nameonly_no_font_style"] = "使用名字模式時，不使用字體描邊（將字型樣式設為空）",
	["nameonly_on_default"] = "當插件無法美化友方名條（如處於副本地城內）而只能顯示暴雪原生名條時，隱藏其血條，只顯示名字。|n|n這個選項會修改CVar |cffffff88nameplateShowOnlyNames|r。",
	["nameonly_target"] = "也在當前目標使用名字模式",
	["powerbar_height"] = "能量條的高度。不能超過名條框架高度",
	["state_icons"] = "在首領與精英單位上顯示圖示（啟用「顯示等級文字」時隱藏）",
	["tank_mode"] = "使用坦克專精時，重新著色你正在坦住的單位血條顏色",
	["tankmode_force_enable"] = "總是使用坦克模式，不管你是否處於坦克專精",
	["tankmode_force_offtank"] = "著色被團隊中其他坦克所坦住的血條，即使你目前並非坦克專精",
	["tankmode_other_colour"] = "當其他坦克接力坦住時的血條顏色。|n|n只對坦克專精生效，並且只對同個團隊中、職責要設定為坦克的角色生效。",
	["tankmode_tank_colour"] = "穩定坦住時的血條顏色",
	["tankmode_trans_colour"] = "獲得或失去仇恨時的血條顏色",
	["target_arrows"] = "在當前目標周圍顯示箭頭。箭頭的顏色繼承目標的光暈顏色。",
	["text_vertical_offset"] = "名條文字的全局垂直偏移量。針對WOW中某些比較奇怪的字體渲染作出微調。注意：尾數設為.5有助於減少名條移動時的抖動現象",
	["threat_brackets"] = "顯示威脅括弧",
	["title_text_players"] = "顯示玩家頭銜",
	["use_blizzard_personal"] = [=[不美化個人資源或是職業能量。|n|n當此選項啟用，個人框架可以在「框架尺寸」中的「個人資源」選項中調整，但是需要重載UI才能完全生效。|n|n要讓此框架顯示，你必須勾選在Esc > 介面 > 名稱 > 單位名條中的「顯示個人資源」選項。|n|n要顯示未被美化的職業資源，必須在同一頁面取消勾選「顯示目標的特殊資源」。|n|n|cffff6666如果當前框架可見，則需要重載UI方能使改動生效。
]=],
}
