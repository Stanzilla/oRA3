local L = LibStub("AceLocale-3.0"):NewLocale("oRA3", "koKR")
if not L then return end

-- Generic
L["Name"] = "이름"
L["Checks"] = "체크"
L["Disband Group"] = "파티 해산"
L["Disbands your current party or raid, kicking everyone from your group, one by one, until you are the last one remaining.\n\nSince this is potentially very destructive, you will be presented with a confirmation dialog. Hold down Control to bypass this dialog."] = "당신이 구성하고 있는 파티/공격대를 모두 해산시킵니다. 각 파티/공대원들은 자동적으로 추방이 되어 솔로 상태가 됩니다."
L["Options"] = "옵션"
L["<oRA3> Disbanding group."] = "<oRA3> 파티를 해산합니다."
L["Are you sure you want to disband your group?"] = "정말로 당신의 파티/공격대를 해산하겠습니까?"
L["Click to open/close oRA3"] = "클릭 - oRA3 열기/닫기"
L["Unknown"] = "알수 없음"

-- Core
L["You can configure some options here. All the actual actions are done from the panel at the RaidFrame."] = "몇 가지의 옵션을 설정할 수있습니다. 모든 실재 동작은 공격대 프레임창에서 패널을 통해 확인가능합니다."

-- Ready check module
L["The following players are not ready: %s"] = "준비가 되지 않은 플레이어: %s"
L["Ready Check (%d seconds)"] = "준비 확인 (%d 초)"
L["Ready"] = "준비 완료"
L["Not Ready"] = "준비 안됨"
L["No Response"] = "응답 없음"
L["Offline"] = "오프라인"
L["Play a sound when a ready check is performed."] = "준비 확인 수행시 소리를 재생합니다."
L["GUI"] = "GUI"
L["Show the oRA3 Ready Check GUI when a ready check is performed."] = "준비 확인 수행시 'oRA3 확인 GUI'를 표시합니다."
L["Auto Hide"] = "자동 숨김"
L["Automatically hide the oRA3 Ready Check GUI when a ready check is finished."] = "준비 확인이 끝나면 'oRA3 확인 GUI'를 자동으로 숨깁니다."

-- Durability module
L["Durability"] = "내구도"
L["Average"] = "평균"
L["Broken"] = "파손"
L["Minimum"] = "최소"

-- Resistances module
L["Resistances"] = "저항력"
L["Frost"] = "냉기"
L["Fire"] = "화염"
L["Shadow"] = "암흑"
L["Nature"] = "자연"
L["Arcane"] = "비전"

-- Resurrection module
L["%s is ressing %s."] = "%s 가 %s 를 부활중입니다."

-- Invite module
L["Invite"] = "초대"
L["All max level characters will be invited to raid in 10 seconds. Please leave your groups."] = "10초 동안 최대 레벨 이상인 길드원들을 공격대에 초대합니다. 파티에서 나와 주세요."
L["All characters in %s will be invited to raid in 10 seconds. Please leave your groups."] = "10초 동안 %s 내의 모든 길드원을 공격대에 초대합니다. 파티에서 나와 주세요."
L["All characters of rank %s or higher will be invited to raid in 10 seconds. Please leave your groups."] = "10초 동안 %s 등급 이상인 길드원들을 공격대에 초대합니다. 파티에서 나와 주세요." 
L["<oRA3> Sorry, the group is full."] = "<oRA3> 죄송합니다. 공격대의 정원이 찼습니다."
L["Invite all guild members of rank %s or higher."] = "%s 등급 이상인 모든 길드원을 공격대에 초대합니다."
L["Keyword"] = "키워드"
L["When people whisper you the keywords below, they will automatically be invited to your group. If you're in a party and it's full, you will convert to a raid group. The keywords will only stop working when you have a full raid of 40 people. Setting a keyword to nothing will disable it."] = "아래 키워드로 사람들이 당신에게 귓속말시에 자동으로 당신의 파티에 초대됩니다. 만약 당신이 파티중이며 5명일경우 자동으로 공격대로 전환됩니다. 공격대가 40명이 찰경우에는 키워드 작동이 더이상되지 않습니다."
L["Anyone who whispers you this keyword will automatically and immediately be invited to your group."] = "설정된 키워드로 귓속말을 하면 즉시 자동으로 자신의 공격대로 초대합니다."
L["Guild Keyword"] = "길드 키워드"
L["Any guild member who whispers you this keyword will automatically and immediately be invited to your group."] = "모든 길드원이 키워드로 당신에게 귓속말시에 자동으로 즉시 파티에 초대됩니다."
L["Invite guild"] = "길드원 초대"
L["Invite everyone in your guild at the maximum level."] = "길드내 최대 레벨의 모든 길드원을 공격대에 초대합니다."
L["Invite zone"] = "지역 초대"
L["Invite everyone in your guild who are in the same zone as you."] = "현재 지역 내의 모든 길드원을 공격대에 초대합니다."
L["Guild rank invites"] = "길드 등급 초대"
L["Clicking any of the buttons below will invite anyone of the selected rank AND HIGHER to your group. So clicking the 3rd button will invite anyone of rank 1, 2 or 3, for example. It will first post a message in either guild or officer chat and give your guild members 10 seconds to leave their groups before doing the actual invites."] = "지정된 등급 이상의 모든 길드원을 공격대에 초대합니다."

-- Promote module
L["Demote everyone"] = "모두 강등"
L["Demotes everyone in the current group."] = "현재 파티/공격대의 모두를 강등시킵니다."
L["Promote"] = "승급"
L["Mass promotion"] = "집단 승급"
L["Everyone"] = "모든 사람"
L["Promote everyone automatically."] = "자동적으로 모든 사람을 승급합니다."
L["Guild"] = "길드"
L["Promote all guild members automatically."] = "자동적으로 모든 길드원을 승급합니다."
L["By guild rank"] = "길드 등급별"
L["Individual promotions"] = "개별적 승급"
L["Note that names are case sensitive. To add a player, enter a player name in the box below and hit Enter or click the button that pops up. To remove a player from being promoted automatically, just click his name in the dropdown below."] = "이름은 대소문자를 구분합니다. 선수를 추가하려면, 아래의 상자에 선수 이름을 입력하고 엔터키를 눌리거나 팝업 버튼을 클릭하세요. 플레이어를 자동으로 제거하려면 승급이 되어야하며 아래의 드롭 다운에서 그의 이름을 클릭하면 됩니다."
L["Add"] = "추가"
L["Remove"] = "삭제"

-- Cooldowns module
L["Cooldowns"] = "재사용 대기시간"
L["Monitor settings"] = "모니터 설정"
L["Show monitor"] = "모니터 표시"
L["Lock monitor"] = "모니터 잠금"
L["Show or hide the cooldown bar display in the game world."] = "게임 환경안에 재사용 대기시간 바를 표시하거나 숨깁니다."
L["Note that locking the cooldown monitor will hide the title and the drag handle and make it impossible to move it, resize it or open the display options for the bars."] = "크기를 조정하거나 바에 대한 표시 옵션을 엽니다. 재사용 대기시간 모니터의 제목을 드래그로 이동 가능하며 모니터 잠금시 제목을 숨깁니다."
L["Only show my own spells"] = "자신의 기술만 표시"
L["Toggle whether the cooldown display should only show the cooldown for spells cast by you, basically functioning as a normal cooldown display addon."] = "일반적인 주문의 재사용 대기시간이나 자신의 주문의 재사용 대기시간을 전환합니다."
L["Cooldown settings"] = "재사용 대기시간 설정"
L["Select which cooldowns to display using the dropdown and checkboxes below. Each class has a small set of spells available that you can view using the bar display. Select a class from the dropdown and then configure the spells for that class according to your own needs."] = "선택한 주문에 대한 재사용 대기시간을 표시합니다."
L["Select class"] = "직업 선택"
L["Never show my own spells"] = "자신의 기술을 표시하지 않음"
L["Toggle whether the cooldown display should never show your own cooldowns. For example if you use another cooldown display addon for your own cooldowns."] = "자신의 재사용 대기시간의 표시하지 않도록 전환합니다. 예를 들어 보통 다른 애드온으로 자신의 재사용 대기시간을 표시를 합니다."

-- monitor
L["Cooldowns"] = "재사용 대기시간"
L["Right-Click me for options!"] = "옵션 설정은 우-클릭!"
L["Bar Settings"] = "바 설정"
L["Spawn test bar"] = "테스트 바 표시"
L["Use class color"] = "직업 색상 사용"
L["Height"] = "높이"
L["Scale"] = "크기"
L["Texture"] = "텍스쳐"
L["Icon"] = "아이콘"
L["Show"] = "보기"
L["Duration"] = "지속 시간"
L["Unit name"] = "유닛 이름"
L["Spell name"] = "주문 이름"
L["Short Spell name"] = "짧은 주문 이름"
L["Label Align"] = "Label 정렬"
L["Left"] = "좌측"
L["Right"] = "우측"
L["Center"] = "중앙"
L["Grow up"] = "성장 방향"

-- Zone module
L["Zone"] = "지역"

-- Version module
L["Version"] = "버전"

-- Loot module
 L["Leave empty to make yourself Master Looter."] = "자신이 담당자 획득이면 비워 둡니다."
 
-- Tanks module
L["Tanks"] = "탱커"
L["Top List: Sorted Tanks. Bottom List: Potential Tanks.\nClick people on the bottom list to put them in the top list."] = "상단 목록: 탱커 정렬. 하단 목록: 가능한 탱커.\n상단 목록에 탱커로 지정하기 위해 하단 목록에 있는 가능한 탱커를 클릭하세요."

