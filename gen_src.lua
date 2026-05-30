License = [[
    MIT License

    Copyright (c) 2026 Vladimir Abramov <abramov7613@yandex.ru>

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following
    conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
]]

if arg[1]==nil or arg[2]==nil then
  error("Usage: lua5.4 "..arg[0]..' header_file_name cpp_file_name')
end

------------ GLOBALS ------------

out1 = assert(io.open(arg[1] ,"w"))
out2 = assert(io.open(arg[2] ,"w"))

INDICTION_LENGTH = 532

DAY_PROPERTIES_ = {
  { 'EASTER', "Светлое Христово Воскресение. ПАСХА." },
  { 'BRIGHT_MON', "Понедельник Светлой седмицы." },
  { 'BRIGHT_TUE', "Вторник Светлой седмицы." },
  { 'BRIGHT_WED', "Среда Светлой седмицы." },
  { 'BRIGHT_THU', "Четверг Светлой седмицы." },
  { 'BRIGHT_FRI', "Пятница Светлой седмицы." },
  { 'BRIGHT_SAT', "Суббота Светлой седмицы." },
  { 'SUN2_AFTER_EASTER', "Неделя 2-я по Пасхе, апостола Фомы́. Антипасха." },
  { 'WEEK2_AFTER_EASTER_MON', "Понедельник 2-й седмицы по Пасхе." },
  { 'WEEK2_AFTER_EASTER_TUE', "Вторник 2-й седмицы по Пасхе. Ра́доница. Поминовение усопших." },
  { 'WEEK2_AFTER_EASTER_WED', "Среда 2-й седмицы по Пасхе." },
  { 'WEEK2_AFTER_EASTER_THU', "Четверг 2-й седмицы по Пасхе." },
  { 'WEEK2_AFTER_EASTER_FRI', "Пятница 2-й седмицы по Пасхе." },
  { 'WEEK2_AFTER_EASTER_SAT', "Суббота 2-й седмицы по Пасхе." },
  { 'SUN3_AFTER_EASTER', "Неделя 3-я по Пасхе, святых жен-мироносиц." },
  { 'WEEK3_AFTER_EASTER_MON', "Понедельник 3-й седмицы по Пасхе." },
  { 'WEEK3_AFTER_EASTER_TUE', "Вторник 3-й седмицы по Пасхе." },
  { 'WEEK3_AFTER_EASTER_WED', "Среда 3-й седмицы по Пасхе." },
  { 'WEEK3_AFTER_EASTER_THU', "Четверг 3-й седмицы по Пасхе." },
  { 'WEEK3_AFTER_EASTER_FRI', "Пятница 3-й седмицы по Пасхе." },
  { 'WEEK3_AFTER_EASTER_SAT', "Суббота 3-й седмицы по Пасхе." },
  { 'SUN4_AFTER_EASTER', "Неделя 4-я по Пасхе, о расслабленном." },
  { 'WEEK4_AFTER_EASTER_MON', "Понедельник 4-й седмицы по Пасхе." },
  { 'WEEK4_AFTER_EASTER_TUE', "Вторник 4-й седмицы по Пасхе." },
  { 'WEEK4_AFTER_EASTER_WED', "Среда 4-й седмицы по Пасхе. Преполове́ние Пятидесятницы." },
  { 'WEEK4_AFTER_EASTER_THU', "Четверг 4-й седмицы по Пасхе." },
  { 'WEEK4_AFTER_EASTER_FRI', "Пятница 4-й седмицы по Пасхе." },
  { 'WEEK4_AFTER_EASTER_SAT', "Суббота 4-й седмицы по Пасхе." },
  { 'SUN5_AFTER_EASTER', "Неделя 5-я по Пасхе, о самаряны́не." },
  { 'WEEK5_AFTER_EASTER_MON', "Понедельник 5-й седмицы по Пасхе." },
  { 'WEEK5_AFTER_EASTER_TUE', "Вторник 5-й седмицы по Пасхе." },
  { 'WEEK5_AFTER_EASTER_WED', "Среда 5-й седмицы по Пасхе. Отдание праздника Преполовения Пятидесятницы." },
  { 'WEEK5_AFTER_EASTER_THU', "Четверг 5-й седмицы по Пасхе." },
  { 'WEEK5_AFTER_EASTER_FRI', "Пятница 5-й седмицы по Пасхе." },
  { 'WEEK5_AFTER_EASTER_SAT', "Суббота 5-й седмицы по Пасхе." },
  { 'SUN6_AFTER_EASTER', "Неделя 6-я по Пасхе, о слепом." },
  { 'WEEK6_AFTER_EASTER_MON', "Понедельник 6-й седмицы по Пасхе." },
  { 'WEEK6_AFTER_EASTER_TUE', "Вторник 6-й седмицы по Пасхе." },
  { 'WEEK6_AFTER_EASTER_WED', "Среда 6-й седмицы по Пасхе. Отдание праздника Пасхи." },
  { 'WEEK6_AFTER_EASTER_THU', "Четверг 6-й седмицы по Пасхе. Вознесе́ние Госпо́дне." },
  { 'WEEK6_AFTER_EASTER_FRI', "Пятница 6-й седмицы по Пасхе. Попразднство Вознесения." },
  { 'WEEK6_AFTER_EASTER_SAT', "Суббота 6-й седмицы по Пасхе. Попразднство Вознесения." },
  { 'SUN7_AFTER_EASTER', "Неделя 7-я по Пасхе. Святых отцов Первого Вселенского Собора." },
  { 'WEEK7_AFTER_EASTER_MON', "Понедельник 7-й седмицы по Пасхе. Попразднство Вознесения." },
  { 'WEEK7_AFTER_EASTER_TUE', "Вторник 7-й седмицы по Пасхе. Попразднство Вознесения." },
  { 'WEEK7_AFTER_EASTER_WED', "Среда 7-й седмицы по Пасхе. Попразднство Вознесения." },
  { 'WEEK7_AFTER_EASTER_THU', "Четверг 7-й седмицы по Пасхе. Попразднство Вознесения." },
  { 'WEEK7_AFTER_EASTER_FRI', "Пятница 7-й седмицы по Пасхе. Отдание праздника Вознесения Господня." },
  { 'WEEK7_AFTER_EASTER_SAT', "Суббота 7-й седмицы по Пасхе. Троицкая родительская суббота." },
  { 'PENTECOST_SUN', "Неделя 8-я по Пасхе. День Святой Тро́ицы. Пятидеся́тница." },
  { 'PENTECOST_MON', "Понедельник Пятидесятницы. День Святаго Духа." },
  { 'PENTECOST_TUE', "Вторник Пятидесятницы." },
  { 'PENTECOST_WED', "Среда Пятидесятницы." },
  { 'PENTECOST_THU', "Четверг Пятидесятницы." },
  { 'PENTECOST_FRI', "Пятница Пятидесятницы." },
  { 'PENTECOST_SAT', "Суббота Пятидесятницы. Отдание праздника Пятидесятницы." },
  { 'SUN1_AFTER_PENTECOST', "Неделя 1-я по Пятидесятнице, Всех святых." },
  { 'SUN2_AFTER_PENTECOST', "Неделя 2-я по Пятидесятнице. Всех святых, в земле Русской просиявших." },
  { 'SUN3_AFTER_PENTECOST', "Неделя 3-я по Пятидесятнице." },
  { 'SUN4_AFTER_PENTECOST', "Неделя 4-я по Пятидесятнице." },
  { 'PUBLICAN_PHARISEE_SUN', "Неделя о мытаре́ и фарисе́е." },
  { 'PRODIGAL_SON_SUN', "Неделя о блудном сыне." },
  { 'MEMORIAL_SAT', "Суббота мясопу́стная. Вселенская родительская суббота." },
  { 'DREAD_JUDGEMENT_SUN', "Неделя мясопу́стная, о Страшном Суде." },
  { 'CHEESE_MON', "Понедельник сырный." },
  { 'CHEESE_TUE', "Вторник сырный." },
  { 'CHEESE_WED', "Среда сырная." },
  { 'CHEESE_THU', "Четверг сырный." },
  { 'CHEESE_FRI', "Пятница сырная." },
  { 'CHEESE_SAT', "Суббота сырная." },
  { 'CHEESE_SUN', "Неделя сыропустная. Воспоминание Адамова изгнания. Прощеное воскресенье." },
  { 'LENT_WEEK1_MON', "Понедельник 1-й седмицы. Начало Великого поста." },
  { 'LENT_WEEK1_TUE', "Вторник 1-й седмицы великого поста." },
  { 'LENT_WEEK1_WED', "Среда 1-й седмицы великого поста." },
  { 'LENT_WEEK1_THU', "Четверг 1-й седмицы великого поста." },
  { 'LENT_WEEK1_FRI', "Пятница 1-й седмицы великого поста." },
  { 'LENT_WEEK1_SAT', "Суббота 1-й седмицы великого поста." },
  { 'LENT_SUN1', "Неделя 1-я Великого поста. Торжество Православия." },
  { 'LENT_WEEK2_MON', "Понедельник 2-й седмицы великого поста." },
  { 'LENT_WEEK2_TUE', "Вторник 2-й седмицы великого поста." },
  { 'LENT_WEEK2_WED', "Среда 2-й седмицы великого поста." },
  { 'LENT_WEEK2_THU', "Четверг 2-й седмицы великого поста." },
  { 'LENT_WEEK2_FRI', "Пятница 2-й седмицы великого поста." },
  { 'LENT_WEEK2_SAT', "Суббота 2-й седмицы великого поста." },
  { 'LENT_SUN2', "Неделя 2-я Великого поста." },
  { 'LENT_WEEK3_MON', "Понедельник 3-й седмицы великого поста." },
  { 'LENT_WEEK3_TUE', "Вторник 3-й седмицы великого поста." },
  { 'LENT_WEEK3_WED', "Среда 3-й седмицы великого поста." },
  { 'LENT_WEEK3_THU', "Четверг 3-й седмицы великого поста." },
  { 'LENT_WEEK3_FRI', "Пятница 3-й седмицы великого поста." },
  { 'LENT_WEEK3_SAT', "Суббота 3-й седмицы великого поста." },
  { 'LENT_SUN3', "Неделя 3-я Великого поста, Крестопоклонная." },
  { 'LENT_WEEK4_MON', "Понедельник 4-й седмицы вел. поста, Крестопоклонной." },
  { 'LENT_WEEK4_TUE', "Вторник 4-й седмицы вел. поста, Крестопоклонной." },
  { 'LENT_WEEK4_WED', "Среда 4-й седмицы вел. поста, Крестопоклонной." },
  { 'LENT_WEEK4_THU', "Четверг 4-й седмицы вел. поста, Крестопоклонной." },
  { 'LENT_WEEK4_FRI', "Пятница 4-й седмицы вел. поста, Крестопоклонной." },
  { 'LENT_WEEK4_SAT', "Суббота 4-й седмицы вел. поста, Крестопоклонной." },
  { 'LENT_SUN4', "Неделя 4-я Великого поста. Прп. Иоанна Лествичника." },
  { 'LENT_WEEK5_MON', "Понедельник 5-й седмицы великого поста." },
  { 'LENT_WEEK5_TUE', "Вторник 5-й седмицы великого поста." },
  { 'LENT_WEEK5_WED', "Среда 5-й седмицы великого поста." },
  { 'LENT_WEEK5_THU', "Четверг 5-й седмицы великого поста." },
  { 'LENT_WEEK5_FRI', "Пятница 5-й седмицы великого поста." },
  { 'LENT_WEEK5_SAT', "Суббота 5-й седмицы великого поста. Суббота Ака́фиста. Похвала́ Пресвятой Богородицы." },
  { 'LENT_SUN5', "Неделя 5-я Великого поста. Прп. Марии Египетской" },
  { 'LENT_WEEK6_MON', "Понедельник 6-й седмицы великого поста, ва́ий." },
  { 'LENT_WEEK6_TUE', "Вторник 6-й седмицы великого поста, ва́ий." },
  { 'LENT_WEEK6_WED', "Среда 6-й седмицы великого поста, ва́ий." },
  { 'LENT_WEEK6_THU', "Четверг 6-й седмицы великого поста, ва́ий." },
  { 'LENT_WEEK6_FRI', "Пятница 6-й седмицы великого поста, ва́ий." },
  { 'LENT_WEEK6_SAT', "Суббота 6-й седмицы великого поста, ва́ий. Лазарева суббота." },
  { 'LENT_SUN7', "Неделя ва́ий (цветоно́сная, Вербное воскресенье). Вход Господень в Иерусалим." },
  { 'LENT_WEEK7_MON', "Страстна́я седмица. Великий Понедельник." },
  { 'LENT_WEEK7_TUE', "Страстна́я седмица. Великий Вторник." },
  { 'LENT_WEEK7_WED', "Страстна́я седмица. Великая Среда." },
  { 'LENT_WEEK7_THU', "Страстна́я седмица. Великий Четверг. Воспоминание Тайной Ве́чери." },
  { 'LENT_WEEK7_FRI', "Страстна́я седмица. Великая Пятница." },
  { 'LENT_WEEK7_SAT', "Страстна́я седмица. Великая Суббота." },
  { 'SAT_BEFORE_EXALTATION', "Суббота пред Воздвижением." },
  { 'SUN_BEFORE_EXALTATION', "Неделя пред Воздвижением." },
  { 'SAT_AFTER_EXALTATION', "Суббота по Воздвижении." },
  { 'SUN_AFTER_EXALTATION', "Неделя по Воздвижении." },
  { 'FATHERS_ECU_COUNCIL_7', "Память святых отцов VII Вселенского Собора." },
  { 'DIMITRI_SAT', "Димитриевская родительская суббота." },
  { 'HOLY_FOREFATHERS_SUN', "Неделя святых пра́отец." },
  { 'SAT_BEFORE_CHRISTMAS', "Суббота пред Рождеством Христовым." },
  { 'SUN_BEFORE_CHRISTMAS', "Неделя пред Рождеством Христовым, святых отец." },
  { 'SAT_AFTER_CHRISTMAS', "Суббота по Рождестве Христовом." },
  { 'SAT_AFTER_CHRISTMAS_READINGS', "Чтения субботы по Рождестве Христовом." },
  { 'SUN_AFTER_CHRISTMAS', "Неделя по Рождестве Христовом." },
  { 'SUN_AFTER_CHRISTMAS_READINGS', "Чтения недели по Рождестве Христовом" },
  { 'SAINTS_JOSEPH_DAVID_JAMES', "Правв. Иосифа Обручника, Давида царя и Иакова, брата Господня." },
  { 'SAT_BEFORE_BAPTISM', "Суббота перед Богоявлением." },
  { 'SUN_BEFORE_BAPTISM', "Неделя перед Богоявлением." },
  { 'SUN_BEFORE_BAPTISM_READINGS', "Чтения недели пред Богоявлением." },
  { 'SAT_AFTER_BAPTISM', "Суббота по Богоявлении." },
  { 'SUN_AFTER_BAPTISM', "Неделя по Богоявлении." },
  { 'NEW_MARTYRS_OF_RUSSIA', "Собор новомучеников и исповедников Церкви Русской." },
  { 'CONVENTION_OF_3_HIERARCHS', "Собор 3-x свят. Василия Великого, Григория Богослова и Иоанна Златоустого." },
  { 'FOREFEAST_GOD_MEETING', "Предпразднство Сре́тения Господня." },
  { 'GOD_MEETING', "Сре́тение Господа Бога и Спаса нашего Иисуса Христа." },
  { 'AFTERFEAST_GOD_MEETING1', "День 1-й Попразднства Сретения Господня." },
  { 'AFTERFEAST_GOD_MEETING2', "День 2-й Попразднства Сретения Господня." },
  { 'AFTERFEAST_GOD_MEETING3', "День 3-й Попразднства Сретения Господня." },
  { 'AFTERFEAST_GOD_MEETING4', "День 4-й Попразднства Сретения Господня." },
  { 'AFTERFEAST_GOD_MEETING5', "День 5-й Попразднства Сретения Господня." },
  { 'AFTERFEAST_GOD_MEETING6', "День 6-й Попразднства Сретения Господня." },
  { 'ENDOF_GOD_MEETING', "Отдание праздника Сретения Господня." },
  { 'JOHN_BAPTIST_HEAD_DISCOVERY_1_2', "Первое и второе Обре́тение главы Иоанна Предтечи." },
  { 'JOHN_BAPTIST_HEAD_DISCOVERY_3', "Третье обре́тение главы Предтечи и Крестителя Господня Иоанна." },
  { 'HOLY_FORTY_MARTYRS_OF_SEBASTE', "Святых сорока́ мучеников, в Севастийском е́зере мучившихся." },
  { 'FOREFEAST_GOD_MOTHER_ANNUNCIATION', "Предпразднство Благовещения Пресвятой Богородицы." },
  { 'ENDOF_GOD_MOTHER_ANNUNCIATION', "Отдание праздника Благовещения Пресвятой Богородицы." },
  { 'HOLY_GREAT_MARTYR_GEORGE', "Вмч. Гео́ргия Победоно́сца. Мц. царицы Александры." },
  { 'FATHERS_ECU_COUNCIL_1_6', "Память святых отцов шести Вселенских Соборов." },
  { 'MOVEABLE_FEAST', "Двунадесятые переходящие праздники" },
  { 'IMMOVEABLE_FEAST', "Двунадесятые непереходящие праздники" },
  { 'GREAT_FEAST', "Великие праздники" },
  { 'GREAT_LENT', "один из дней великого поста" },
  { 'APOSTOL_LENT', "один из дней Петрова поста" },
  { 'CHRISTMAS_LENT', "один из дней Рождественского поста" },
  { 'ASSUMPTION_LENT', "один из дней Успенского поста" },
  { 'SOLID_WEEK_BRIGHT', "один из дней сплошной седмицы. Светлая" },
  { 'SOLID_WEEK_CHRISTMAS', "один из дней сплошной седмицы. Рождественская" },
  { 'SOLID_WEEK_PENTECOST', "один из дней сплошной седмицы. Троицкая" },
  { 'SOLID_WEEK_CHEESE', "один из дней сплошной седмицы. Сырная (Масленица)" },
  { 'SOLID_WEEK_PUBLICAN_PHARISEE', "один из дней сплошной седмицы. Мытаря и фарисея" },
}
DAY_PROPERTIES = {}
for i,v in ipairs(DAY_PROPERTIES_) do
  DAY_PROPERTIES[v[1]] = i-1
end

function check_y(y)
  if type(y)~='number' or (y<1 or y>INDICTION_LENGTH) then return false end
  return true
end

function easter(year)
  if not check_y(year) then error"easter function error" end
  year = year + 1940
  local  m = 3
  local  a = year % 19
  local  b = year % 4
  local  c = year % 7
  local  d = (19*a+15) % 30
  local  e = (2*b+4*c+6*d+6) % 7
  local  p = 22 + d + e
  if p>31 then
    p = d + e - 9;
    m  = 4;
  end
  return m, p
end

function check_m(m)
  if type(m)~='number' or (m<1 or m>12) then return false end
  return true
end

function leap(y)
  if not check_y(y) then error"leap error" end
  return (y+1940)%4 == 0
end

function m_size(m, leap)
  if not check_m(m) or type(leap)~='boolean' then
    error"m_size error"
  end
  if m==2 then
    if leap then return 29 end
    return 28
  end
  if m==1 or m==3 or m==5 or m==7 or m==8 or m==10 or m==12 then
    return 31
  end
  return 30
end

function check_ymd(y,m,d)
  if not check_y(y) or not check_m(m) then return false end
  if type(d)~='number' or d<1 or d>m_size(m, leap(y)) then return false end
  return true
end

function to_binary_str(x, c)
  if math.type(x)~='integer' then error"to_binary_str error" end
  c = c or 0
  local result = ""
  if x==0 then result = tostring(x)
  else
    local s = {}
    while x > 0 do
        local tmp = x % 2
        table.insert(s, tmp)  -- Collect the remainder
        x = math.floor(x / 2)  -- Divide by 2
    end
    for i = #s, 1, -1 do -- Reverse the collected bits to form the binary string
        result = result .. s[i]
    end
  end
  c = c - #result
  while c>0 do
    result = '0' .. result
    c = c - 1
  end
  return result
end

DD = {} -- class for date implementation

function DD:new(Y, M, D) -- constructor (year, month, day)
  if not check_ymd(Y,M,D) then error"DD:new error" end
  local t = { y=Y, m=M, d=D }
  setmetatable(t, self)
  self.__index = self
  return t
end

function DD:assign(t) -- assign operation where 't' is table as { [y,] m, d }
  if type(t)~='table' then error"DD:assign error" end
  if #t==2 then
    self.m = t[1]
    self.d = t[2]
  elseif #t==3 then
    self.y = t[1]
    self.m = t[2]
    self.d = t[3]
  else
    error"DD:assign error - invalid size of t"
  end
  if not check_ymd(self.y, self.m, self.d) then error"DD:assign error" end
  return self
end

function DD:__call(y,m,d)
  return self:assign({y,m,d})
end

function DD:__tostring()
  return self.y .. '.' .. self.m .. '.' .. self.d
end

function DD:__eq(rhs)
  return self.y==rhs.y and self.m==rhs.m and self.d==rhs.d
end

function DD:__lt(rhs)
  if self.y < rhs.y then return true end
  if self.y > rhs.y then return false end
  if self.m < rhs.m then return true end
  if self.m > rhs.m then return false end
  return self.d < rhs.d
end

function DD:__le(rhs)
  return self == rhs or self < rhs
end

function DD:l() -- return true if current year is leap
  return leap(self.y)
end

function DD:ml() -- return month length
  return m_size(self.m, self:l())
end

function DD:wd() -- return weekday as 0=sun, 1=mon ...
  local fdiv = function(a,b)
    local x = 0
    if a<0 then x = b-1 end
    local r = math.modf((a - x) / b)
    return r
  end
  local Y = self.y + 1940
  local c0 = fdiv((self.m - 3) , 12)
  local j1 = fdiv(1461 * (Y + c0), 4)
  local j2 = fdiv(153 * self.m - 1836 * c0 - 457, 5)
  local cjdn = j1 + j2 + self.d + 1721117
  local result = (cjdn+1) % 7
  return result
end

function DD:icp(c) -- increment copy ( not jump over the year )
  c = c or 1
  if c<1 then error"DD:icp error" end
  local M = self.m
  local D = self.d + c
  local L = self:l()
  local U = self:ml()
  while D>U do
    D = D - U
    M = M + 1
    if M>12 then return DD:new(self.y, self.m, self.d) end
    U = m_size(M, L)
  end
  return DD:new(self.y, M, D)
end

function DD:dcp(c) -- decrement copy ( not jump over the year )
  c = c or 1
  if c<1 then error"DD:dcp error" end
  local M = self.m
  local D = self.d - c
  local L = self:l()
  local U = self:ml()
  while D<1 do
    M = M - 1
    if M<1 then return DD:new(self.y, self.m, self.d) end
    U = m_size(M, L)
    D = D + U
  end
  return DD:new(self.y, M, D)
end

function DD:i(c) -- increment self ( not jump over the year )
  local x = self:icp(c)
  self.m = x.m
  self.d = x.d
  return self
end

function DD:d(c) -- decrement self ( not jump over the year )
  local x = self:dcp(c)
  self.m = x.m
  self.d = x.d
  return self
end

function DD:I(c) -- increment self
  c = c or 1
  if c<1 then error"DD:I error" end
  local U = self:ml()
  self.d = self.d + c
  while self.d>U do
    self.d = self.d - U
    self.m = self.m + 1
    if self.m>12 then
      self.m = 1
      self.y = self.y + 1
      if self.y>INDICTION_LENGTH then self.y = 1 end
    end
    U = self:ml()
  end
  return self
end

function DD:D(c) -- decrement self
  c = c or 1
  if c<1 then error"DD:I error" end
  local U = self:ml()
  self.d = self.d - c
  while self.d<1 do
    self.m = self.m - 1
    if self.m<1 then
      self.m = 12
      self.y = self.y - 1
      if self.y<1 then self.y = INDICTION_LENGTH end
    end
    U = self:ml()
    self.d = self.d + U
  end
  return self
end

function DD:set_to_wd_after(weekday) -- change date to first weekday after current
  repeat
    if(weekday == self:wd()) then break; end
    self:I()
  until false
  return self
end

function DD:set_to_wd_before(weekday) -- change date to first weekday before current
  repeat
    if(weekday == self:wd()) then break; end
    self:D()
  until false
  return self
end

--##################################################################
--####################  Generate header file  ######################
--##################################################################
do
  local h1 = [[
#pragma once
#include <utility>
#include <initializer_list>
#include <vector>

namespace full_indiction {

constexpr auto INDICTION_LENGTH = 532 ;

using MonthDay = std::pair<int,int> ;

enum class DayProperty {]]
  out1:write('/*\n', License, '*/\n', h1, '\n')
  for _,v in ipairs(DAY_PROPERTIES_) do
    out1:write('  ', v[1], ',///< ', v[2], '\n')
  end
  out1:write('  SIZE_\n};\n')
  local h2 = [[
using enum DayProperty ;
// таблица псевдонимов
constexpr auto MOVE_F = MOVEABLE_FEAST ;
constexpr auto IMMOVE_F = IMMOVEABLE_FEAST ;
constexpr auto GREAT_F = GREAT_FEAST ;
constexpr auto PASHA = EASTER ;
constexpr auto PASCHA = EASTER ;
constexpr auto RESURRECTION = EASTER ;
constexpr auto L_MON = BRIGHT_MON ;
constexpr auto L_TUE = BRIGHT_TUE ;
constexpr auto L_WED = BRIGHT_WED ;
constexpr auto L_THU = BRIGHT_THU ;
constexpr auto L_FRI = BRIGHT_FRI ;
constexpr auto L_SAT = BRIGHT_SAT ;
constexpr auto FOMA_SUN =   SUN2_AFTER_EASTER      ;
constexpr auto ANTIPASHA =   SUN2_AFTER_EASTER      ;
constexpr auto ANTIPASCHA =   SUN2_AFTER_EASTER      ;
constexpr auto SUN2_A_E =   SUN2_AFTER_EASTER      ;
constexpr auto RADONICA =   WEEK2_AFTER_EASTER_TUE ;
constexpr auto MID_PENTECOST = WEEK4_AFTER_EASTER_WED ;
constexpr auto W2_A_E_MON = WEEK2_AFTER_EASTER_MON ;
constexpr auto W2_A_E_TUE = WEEK2_AFTER_EASTER_TUE ;
constexpr auto W2_A_E_WED = WEEK2_AFTER_EASTER_WED ;
constexpr auto W2_A_E_THU = WEEK2_AFTER_EASTER_THU ;
constexpr auto W2_A_E_FRI = WEEK2_AFTER_EASTER_FRI ;
constexpr auto W2_A_E_SAT = WEEK2_AFTER_EASTER_SAT ;
constexpr auto SUN3_A_E =   SUN3_AFTER_EASTER      ;
constexpr auto W3_A_E_MON = WEEK3_AFTER_EASTER_MON ;
constexpr auto W3_A_E_TUE = WEEK3_AFTER_EASTER_TUE ;
constexpr auto W3_A_E_WED = WEEK3_AFTER_EASTER_WED ;
constexpr auto W3_A_E_THU = WEEK3_AFTER_EASTER_THU ;
constexpr auto W3_A_E_FRI = WEEK3_AFTER_EASTER_FRI ;
constexpr auto W3_A_E_SAT = WEEK3_AFTER_EASTER_SAT ;
constexpr auto SUN4_A_E =   SUN4_AFTER_EASTER      ;
constexpr auto W4_A_E_MON = WEEK4_AFTER_EASTER_MON ;
constexpr auto W4_A_E_TUE = WEEK4_AFTER_EASTER_TUE ;
constexpr auto W4_A_E_WED = WEEK4_AFTER_EASTER_WED ;
constexpr auto W4_A_E_THU = WEEK4_AFTER_EASTER_THU ;
constexpr auto W4_A_E_FRI = WEEK4_AFTER_EASTER_FRI ;
constexpr auto W4_A_E_SAT = WEEK4_AFTER_EASTER_SAT ;
constexpr auto SUN5_A_E =   SUN5_AFTER_EASTER      ;
constexpr auto W5_A_E_MON = WEEK5_AFTER_EASTER_MON ;
constexpr auto W5_A_E_TUE = WEEK5_AFTER_EASTER_TUE ;
constexpr auto W5_A_E_WED = WEEK5_AFTER_EASTER_WED ;
constexpr auto ENDOF_MID_PENTECOST = WEEK5_AFTER_EASTER_WED ;
constexpr auto W5_A_E_THU = WEEK5_AFTER_EASTER_THU ;
constexpr auto W5_A_E_FRI = WEEK5_AFTER_EASTER_FRI ;
constexpr auto W5_A_E_SAT = WEEK5_AFTER_EASTER_SAT ;
constexpr auto SUN6_A_E =   SUN6_AFTER_EASTER      ;
constexpr auto W6_A_E_MON = WEEK6_AFTER_EASTER_MON ;
constexpr auto W6_A_E_TUE = WEEK6_AFTER_EASTER_TUE ;
constexpr auto W6_A_E_WED = WEEK6_AFTER_EASTER_WED ;
constexpr auto ENDOF_PASHA = WEEK6_AFTER_EASTER_WED ;
constexpr auto ENDOF_PASCHA = WEEK6_AFTER_EASTER_WED ;
constexpr auto ENDOF_EASTER = WEEK6_AFTER_EASTER_WED ;
constexpr auto W6_A_E_THU = WEEK6_AFTER_EASTER_THU ;
constexpr auto ASCENSION = WEEK6_AFTER_EASTER_THU ;
constexpr auto W6_A_E_FRI = WEEK6_AFTER_EASTER_FRI ;
constexpr auto W6_A_E_SAT = WEEK6_AFTER_EASTER_SAT ;
constexpr auto SUN7_A_E =   SUN7_AFTER_EASTER      ;
constexpr auto W7_A_E_MON = WEEK7_AFTER_EASTER_MON ;
constexpr auto W7_A_E_TUE = WEEK7_AFTER_EASTER_TUE ;
constexpr auto W7_A_E_WED = WEEK7_AFTER_EASTER_WED ;
constexpr auto W7_A_E_THU = WEEK7_AFTER_EASTER_THU ;
constexpr auto W7_A_E_FRI = WEEK7_AFTER_EASTER_FRI ;
constexpr auto ENDOF_ASCENSION = WEEK7_AFTER_EASTER_FRI ;
constexpr auto W7_A_E_SAT = WEEK7_AFTER_EASTER_SAT ;
constexpr auto TRINITY_SAT = WEEK7_AFTER_EASTER_SAT ;
constexpr auto TRINITY_SUN = PENTECOST_SUN  ;
constexpr auto PENTECOST = PENTECOST_SUN  ;
constexpr auto HOLY_SPIRIT_DAY = PENTECOST_MON  ;
constexpr auto P_SUN = PENTECOST_SUN  ;
constexpr auto P_MON = PENTECOST_MON  ;
constexpr auto P_TUE = PENTECOST_TUE  ;
constexpr auto P_WED = PENTECOST_WED  ;
constexpr auto P_THU = PENTECOST_THU  ;
constexpr auto P_FRI = PENTECOST_FRI  ;
constexpr auto P_SAT = PENTECOST_SAT  ;
constexpr auto ENDOF_PENTECOST = PENTECOST_SAT  ;
constexpr auto ALL_SAINTS = SUN1_AFTER_PENTECOST ;
constexpr auto ALL_RUS_SAINTS = SUN2_AFTER_PENTECOST ;
constexpr auto SUN1_A_P = SUN1_AFTER_PENTECOST ;
constexpr auto SUN2_A_P = SUN2_AFTER_PENTECOST ;
constexpr auto SUN3_A_P = SUN3_AFTER_PENTECOST ;
constexpr auto SUN4_A_P = SUN4_AFTER_PENTECOST ;
constexpr auto SAT_B_EX = SAT_BEFORE_EXALTATION ;
constexpr auto SUN_B_EX = SUN_BEFORE_EXALTATION ;
constexpr auto SAT_A_EX = SAT_AFTER_EXALTATION ;
constexpr auto SUN_A_EX = SUN_AFTER_EXALTATION ;
constexpr auto COUNCIL_7 = FATHERS_ECU_COUNCIL_7 ;
constexpr auto SAT_B_XMAS = SAT_BEFORE_CHRISTMAS ;
constexpr auto SUN_B_XMAS = SUN_BEFORE_CHRISTMAS ;
constexpr auto SAT_A_XMAS = SAT_AFTER_CHRISTMAS  ;
constexpr auto SAT_A_XMAS_R = SAT_AFTER_CHRISTMAS_READINGS ;
constexpr auto SUN_A_XMAS = SUN_AFTER_CHRISTMAS  ;
constexpr auto SUN_A_XMAS_R = SUN_AFTER_CHRISTMAS_READINGS  ;
constexpr auto SAT_B_NATIVITY = SAT_BEFORE_CHRISTMAS ;
constexpr auto SUN_B_NATIVITY = SUN_BEFORE_CHRISTMAS ;
constexpr auto SAT_A_NATIVITY = SAT_AFTER_CHRISTMAS  ;
constexpr auto SAT_A_NATIVITY_R = SAT_AFTER_CHRISTMAS_READINGS ;
constexpr auto SUN_A_NATIVITY = SUN_AFTER_CHRISTMAS  ;
constexpr auto SUN_A_NATIVITY_R = SUN_AFTER_CHRISTMAS_READINGS  ;
constexpr auto JUDG_SUN = DREAD_JUDGEMENT_SUN ;
constexpr auto FORGIVENESS_SUN = CHEESE_SUN ;
constexpr auto LENT_BEGIN = LENT_WEEK1_MON ;
constexpr auto LE_W1_MON = LENT_WEEK1_MON ;
constexpr auto LE_W1_TUE = LENT_WEEK1_TUE ;
constexpr auto LE_W1_WED = LENT_WEEK1_WED ;
constexpr auto LE_W1_THU = LENT_WEEK1_THU ;
constexpr auto LE_W1_FRI = LENT_WEEK1_FRI ;
constexpr auto LE_W1_SAT = LENT_WEEK1_SAT ;
constexpr auto CLEAN_MON = LENT_WEEK1_MON ;
constexpr auto CLEAN_TUE = LENT_WEEK1_TUE ;
constexpr auto CLEAN_WED = LENT_WEEK1_WED ;
constexpr auto CLEAN_THU = LENT_WEEK1_THU ;
constexpr auto CLEAN_FRI = LENT_WEEK1_FRI ;
constexpr auto THEODOR_SAT = LENT_WEEK1_SAT ;
constexpr auto FEODOR_SAT = LENT_WEEK1_SAT ;
constexpr auto LE_SUN1   = LENT_SUN1      ;
constexpr auto LE_W2_MON = LENT_WEEK2_MON ;
constexpr auto LE_W2_TUE = LENT_WEEK2_TUE ;
constexpr auto LE_W2_WED = LENT_WEEK2_WED ;
constexpr auto LE_W2_THU = LENT_WEEK2_THU ;
constexpr auto LE_W2_FRI = LENT_WEEK2_FRI ;
constexpr auto LE_W2_SAT = LENT_WEEK2_SAT ;
constexpr auto LE_SUN2   = LENT_SUN2      ;
constexpr auto GREGORY_PALAMA  = LENT_SUN2  ;
constexpr auto LE_W3_MON = LENT_WEEK3_MON ;
constexpr auto LE_W3_TUE = LENT_WEEK3_TUE ;
constexpr auto LE_W3_WED = LENT_WEEK3_WED ;
constexpr auto LE_W3_THU = LENT_WEEK3_THU ;
constexpr auto LE_W3_FRI = LENT_WEEK3_FRI ;
constexpr auto LE_W3_SAT = LENT_WEEK3_SAT ;
constexpr auto LE_SUN3   = LENT_SUN3      ;
constexpr auto LE_W4_MON = LENT_WEEK4_MON ;
constexpr auto LE_W4_TUE = LENT_WEEK4_TUE ;
constexpr auto LE_W4_WED = LENT_WEEK4_WED ;
constexpr auto LE_W4_THU = LENT_WEEK4_THU ;
constexpr auto LE_W4_FRI = LENT_WEEK4_FRI ;
constexpr auto LE_W4_SAT = LENT_WEEK4_SAT ;
constexpr auto LE_SUN4   = LENT_SUN4      ;
constexpr auto IOAN_LADDER = LENT_SUN4 ;
constexpr auto LE_W5_MON = LENT_WEEK5_MON ;
constexpr auto LE_W5_TUE = LENT_WEEK5_TUE ;
constexpr auto LE_W5_WED = LENT_WEEK5_WED ;
constexpr auto LE_W5_THU = LENT_WEEK5_THU ;
constexpr auto LE_W5_FRI = LENT_WEEK5_FRI ;
constexpr auto LE_W5_SAT = LENT_WEEK5_SAT ;
constexpr auto AKAFIST_SAT = LENT_WEEK5_SAT ;
constexpr auto LE_SUN5   = LENT_SUN5      ;
constexpr auto MARY_OF_EGYPT = LENT_SUN5 ;
constexpr auto LE_W6_MON = LENT_WEEK6_MON ;
constexpr auto LE_W6_TUE = LENT_WEEK6_TUE ;
constexpr auto LE_W6_WED = LENT_WEEK6_WED ;
constexpr auto LE_W6_THU = LENT_WEEK6_THU ;
constexpr auto LE_W6_FRI = LENT_WEEK6_FRI ;
constexpr auto LE_W6_SAT = LENT_WEEK6_SAT ;
constexpr auto PALM_MON = LENT_WEEK6_MON ;
constexpr auto PALM_TUE = LENT_WEEK6_TUE ;
constexpr auto PALM_WED = LENT_WEEK6_WED ;
constexpr auto PALM_THU = LENT_WEEK6_THU ;
constexpr auto PALM_FRI = LENT_WEEK6_FRI ;
constexpr auto PALM_SAT = LENT_WEEK6_SAT ;
constexpr auto LAZAR_SAT = LENT_WEEK6_SAT ;
constexpr auto LE_SUN7   = LENT_SUN7      ;
constexpr auto PALM_SUN   = LENT_SUN7     ;
constexpr auto LE_W7_MON = LENT_WEEK7_MON ;
constexpr auto LE_W7_TUE = LENT_WEEK7_TUE ;
constexpr auto LE_W7_WED = LENT_WEEK7_WED ;
constexpr auto LE_W7_THU = LENT_WEEK7_THU ;
constexpr auto LE_W7_FRI = LENT_WEEK7_FRI ;
constexpr auto LE_W7_SAT = LENT_WEEK7_SAT ;
constexpr auto GREAT_MON = LENT_WEEK7_MON ;
constexpr auto GREAT_TUE = LENT_WEEK7_TUE ;
constexpr auto GREAT_WED = LENT_WEEK7_WED ;
constexpr auto GREAT_THU = LENT_WEEK7_THU ;
constexpr auto GREAT_FRI = LENT_WEEK7_FRI ;
constexpr auto GREAT_SAT = LENT_WEEK7_SAT ;
constexpr auto G_MON = LENT_WEEK7_MON ;
constexpr auto G_TUE = LENT_WEEK7_TUE ;
constexpr auto G_WED = LENT_WEEK7_WED ;
constexpr auto G_THU = LENT_WEEK7_THU ;
constexpr auto G_FRI = LENT_WEEK7_FRI ;
constexpr auto G_SAT = LENT_WEEK7_SAT ;
constexpr auto LENT_END = LENT_WEEK7_SAT ;
constexpr auto SAT_BEFORE_THEOPHANY = SAT_BEFORE_BAPTISM ;
constexpr auto SUN_BEFORE_THEOPHANY = SUN_BEFORE_BAPTISM ;
constexpr auto SAT_AFTER_THEOPHANY  = SAT_AFTER_BAPTISM  ;
constexpr auto SUN_AFTER_THEOPHANY  = SUN_AFTER_BAPTISM  ;
constexpr auto SAT_B_THEOPHANY = SAT_BEFORE_BAPTISM ;
constexpr auto SUN_B_THEOPHANY = SUN_BEFORE_BAPTISM ;
constexpr auto SAT_A_THEOPHANY  = SAT_AFTER_BAPTISM  ;
constexpr auto SUN_A_THEOPHANY  = SUN_AFTER_BAPTISM  ;
constexpr auto SAT_B_BAPTISM   = SAT_BEFORE_BAPTISM ;
constexpr auto SUN_B_BAPTISM   = SUN_BEFORE_BAPTISM ;
constexpr auto SAT_A_BAPTISM    = SAT_AFTER_BAPTISM  ;
constexpr auto SUN_A_BAPTISM    = SUN_AFTER_BAPTISM  ;
constexpr auto RUS_MARTYRS    = NEW_MARTYRS_OF_RUSSIA  ;
constexpr auto HIERARCHS_3 = CONVENTION_OF_3_HIERARCHS;
constexpr auto FF_GOD_MEETING = FOREFEAST_GOD_MEETING;
constexpr auto AF_GOD_MEETING1 = AFTERFEAST_GOD_MEETING1 ;
constexpr auto AF_GOD_MEETING2 = AFTERFEAST_GOD_MEETING2 ;
constexpr auto AF_GOD_MEETING3 = AFTERFEAST_GOD_MEETING3 ;
constexpr auto AF_GOD_MEETING4 = AFTERFEAST_GOD_MEETING4 ;
constexpr auto AF_GOD_MEETING5 = AFTERFEAST_GOD_MEETING5 ;
constexpr auto AF_GOD_MEETING6 = AFTERFEAST_GOD_MEETING6 ;
constexpr auto IOAN_HEAD_FINDING_12 = JOHN_BAPTIST_HEAD_DISCOVERY_1_2 ;
constexpr auto IOAN_HEAD_FINDING_3 = JOHN_BAPTIST_HEAD_DISCOVERY_3 ;
constexpr auto MARTYRS_40 = HOLY_FORTY_MARTYRS_OF_SEBASTE ;
constexpr auto FF_ANNUNCIATION = FOREFEAST_GOD_MOTHER_ANNUNCIATION ;
constexpr auto ENDOF_ANNUNCIATION = ENDOF_GOD_MOTHER_ANNUNCIATION ;
constexpr auto MARTYR_GEORG = HOLY_GREAT_MARTYR_GEORGE ;
constexpr auto COUNCIL_1_6 = FATHERS_ECU_COUNCIL_1_6 ;

MonthDay easter_date(const int year_number_in_full_indiction) ;
MonthDay find_date(const int year_number_in_full_indiction, const DayProperty property) ;
int apostol_fast_length(const int year_number_in_full_indiction) ;
bool is_date_of(const int year_number_in_full_indiction, const MonthDay date, const DayProperty property) ;
std::vector<MonthDay> find_all_dates(const int year_number_in_full_indiction, const DayProperty property) ;
std::vector<MonthDay> find_all_dates(const int year_number_in_full_indiction,
                                     std::initializer_list<DayProperty> properties) ;
//std::vector<DayProperty> get_day_properties(const int year_number_in_full_indiction, const MonthDay date) ;
//int get_n50(const int year_number_in_full_indiction, const MonthDay date) ;

} // namespace full_indiction]]
  out1:write(h2, '\n')
  assert(out1:close())
end
--##################################################################
--#################   Generate cpp file   ##########################
--##################################################################
do
  out2:write('/*\n', License, '*/\n')
  out2:write('#include "', arg[1], '"\n')
  local c1 = [[
#include <array>
#include <stdexcept>
#include <bitset>
#include <algorithm>
#include <string>

namespace {

using namespace full_indiction ;

constexpr void check_year_number(const int year_number_in_full_indiction)
{
  if (year_number_in_full_indiction < 1 || year_number_in_full_indiction > INDICTION_LENGTH)
    throw std::runtime_error("full_indiction: value of 'year_number_in_full_indiction' must be in range [1,533)");
}

constexpr void check_property_number(DayProperty p)
{
  auto pnum = static_cast<int>(p);
  auto max = static_cast<int>(DayProperty::SIZE_) - 1;
  if (pnum < 0 || pnum > max)
    throw std::runtime_error("full_indiction: invalid DayProperty value");
}

constexpr bool is_leap(const int year_number_in_great_indiction)
{
  check_year_number(year_number_in_great_indiction) ;
  const int year = year_number_in_great_indiction + 1940 ;
  return (year%4 == 0) ;
}

constexpr int month_length(const int month, const bool leap)
{
  switch(month) {
    case 1:
    case 3:
    case 5:
    case 7:
    case 8:
    case 10:
    case 12:
        return 31;
        break;
    case 4:
    case 6:
    case 9:
    case 11:
        return 30;
        break;
    case 2:
        return leap ? 29 : 28;
        break;
    default:
        return 0;
  }
}

constexpr void check_date(const int year_number_in_full_indiction, const MonthDay date)
{
  check_year_number(year_number_in_full_indiction);
  if (date.first < 1 || date.first > 12)
    throw std::runtime_error("full_indiction: invalid month number");
  if (date.second < 1 || date.second > month_length(date.first, is_leap(year_number_in_full_indiction)))
    throw std::runtime_error("full_indiction: invalid day number");
}]]
  out2:write(c1, '\n\n')
  -- array with first index  = "PROPERTY_NAME"
  --            second index =  year number
  --            value        =  array of dates in format: { m=x, d=y }
  local array_of_dates_by_property_and_year = {}
  -- maximum size of third sub-array
  local MAX_DATES_COUNT = 0
  -- save value to array method: where 'd' is DD object, 'p' is PROPERTY_NAME string
  local set = function(d, p)
    if not check_ymd(d.y, d.m, d.d) then error"function set error: invalid DD object" end
    if not DAY_PROPERTIES[p] then error("function set error: invalid property '"..p.."'") end
    array_of_dates_by_property_and_year[p] = array_of_dates_by_property_and_year[p] or {}
    for y = 1, INDICTION_LENGTH do
      array_of_dates_by_property_and_year[p][y] = array_of_dates_by_property_and_year[p][y] or {}
    end
    local sz = #array_of_dates_by_property_and_year[p][d.y] + 1
    if sz > MAX_DATES_COUNT then MAX_DATES_COUNT = sz end
    array_of_dates_by_property_and_year[p][d.y][sz] = { m = d.m, d = d.d }
  end
  -- begin fill 'array_of_dates_by_property_and_year' loop
  for year = 1, INDICTION_LENGTH do
    -- точки отсчета
    local pasha = DD:new(year, easter(year))
    local ascension = pasha:icp(39)
    local pentecost = ascension:icp(10);
    local all_saints = pentecost:icp(7);
    local publican_pharisee = pasha:dcp(70);
    local prodigal_son = publican_pharisee:icp(7);
    local dread_judgement = publican_pharisee:icp(14);
    local forgiveness = publican_pharisee:icp(21);
    local lent_begin = forgiveness:icp(1);
    local palm_sun = lent_begin:icp(41);
    -- Сре́тение Господа Бога и Спаса нашего Иисуса Христа
    local dd = DD:new(year,2,2)
    local t1 = publican_pharisee:icp(13)
    if dd >= lent_begin then dd = forgiveness; end
    set(dd, 'GOD_MEETING');
    local god_meeting = dd;
    if dd == t1 then t1 = publican_pharisee:icp(6); end
    set(t1, 'MEMORIAL_SAT');
    local memorial_sat = t1;
    -- Предпразднство Сре́тения
    local t2 = DD:new(year, 2, 1)
    if dd ~= t2 then
      if(t2 == t1) then t2:D() end
      set(t2, 'FOREFEAST_GOD_MEETING')
    end
    -- отдание праздника Сре́тения
    t1 = prodigal_son
    t2 = t1:icp(2)
    local t3 = DD:new(year, 2, 9)
    if(dd>=t1 and dd<=t2) then
      t3 = t1:icp(5);
    end
    t1 = t1:icp(3);
    t2 = t1:icp(3);
    if(dd>=t1 and dd<=t2) then
      t3 = dread_judgement:icp(2);
    end
    t1 = dread_judgement;
    t2 = dread_judgement:icp(1);
    if(dd>=t1 and dd<=t2) then
      t3 = dread_judgement:icp(4);
    end
    t1 = dread_judgement:icp(2);
    t2 = dread_judgement:icp(3);
    if(dd>=t1 and dd<=t2) then
      t3 = dread_judgement:icp(6);
    end
    t1 = dread_judgement:icp(4);
    t2 = dread_judgement:icp(6);
    if(dd>=t1 and dd<=t2) then
      t3 = forgiveness;
    end
    if(dd ~= forgiveness) then
      if(t3 == memorial_sat) then t3:D() end
      set(t3, 'ENDOF_GOD_MEETING')
    end
    -- Попразднствa Сретения Господня
    t1 = dd:icp(1);
    t2 = t1;
    local i = 1;
    if(dd ~= forgiveness and t3 ~= t1) then
      repeat
        if(t2 == memorial_sat) then
          t2:I()
          if(t2>=t3) then break; end
        end
        set(t2, 'AFTERFEAST_GOD_MEETING'..i)
        t2:I()
        i = i+1
      until t2 == t3
    end
    --  от Недели о мытаре́ и фарисе́е до дня Всех святых.
    set(publican_pharisee, 'PUBLICAN_PHARISEE_SUN')
    set(prodigal_son, 'PRODIGAL_SON_SUN')
    set(dread_judgement, 'DREAD_JUDGEMENT_SUN')
    set(dread_judgement:icp(1), 'CHEESE_MON')
    set(dread_judgement:icp(2), 'CHEESE_TUE')
    set(dread_judgement:icp(3), 'CHEESE_WED')
    set(dread_judgement:icp(4), 'CHEESE_THU')
    set(dread_judgement:icp(5), 'CHEESE_FRI')
    set(dread_judgement:icp(6), 'CHEESE_SAT')
    set(forgiveness, 'CHEESE_SUN')
    set(lent_begin, 'LENT_WEEK1_MON')
    set(lent_begin:icp(1), 'LENT_WEEK1_TUE')
    set(lent_begin:icp(2), 'LENT_WEEK1_WED')
    set(lent_begin:icp(3), 'LENT_WEEK1_THU')
    set(lent_begin:icp(4), 'LENT_WEEK1_FRI')
    set(lent_begin:icp(5), 'LENT_WEEK1_SAT')
    set(lent_begin:icp(6), 'LENT_SUN1')
    set(lent_begin:icp(7), 'LENT_WEEK2_MON')
    set(lent_begin:icp(8), 'LENT_WEEK2_TUE')
    set(lent_begin:icp(9), 'LENT_WEEK2_WED')
    set(lent_begin:icp(10), 'LENT_WEEK2_THU')
    set(lent_begin:icp(11), 'LENT_WEEK2_FRI')
    set(lent_begin:icp(12), 'LENT_WEEK2_SAT')
    set(lent_begin:icp(13), 'LENT_SUN2')
    set(lent_begin:icp(14), 'LENT_WEEK3_MON')
    set(lent_begin:icp(15), 'LENT_WEEK3_TUE')
    set(lent_begin:icp(16), 'LENT_WEEK3_WED')
    set(lent_begin:icp(17), 'LENT_WEEK3_THU')
    set(lent_begin:icp(18), 'LENT_WEEK3_FRI')
    set(lent_begin:icp(19), 'LENT_WEEK3_SAT')
    set(lent_begin:icp(20), 'LENT_SUN3')
    set(lent_begin:icp(21), 'LENT_WEEK4_MON')
    set(lent_begin:icp(22), 'LENT_WEEK4_TUE')
    set(lent_begin:icp(23), 'LENT_WEEK4_WED')
    set(lent_begin:icp(24), 'LENT_WEEK4_THU')
    set(lent_begin:icp(25), 'LENT_WEEK4_FRI')
    set(lent_begin:icp(26), 'LENT_WEEK4_SAT')
    set(lent_begin:icp(27), 'LENT_SUN4')
    set(lent_begin:icp(28), 'LENT_WEEK5_MON')
    set(lent_begin:icp(29), 'LENT_WEEK5_TUE')
    set(lent_begin:icp(30), 'LENT_WEEK5_WED')
    set(lent_begin:icp(31), 'LENT_WEEK5_THU')
    set(lent_begin:icp(32), 'LENT_WEEK5_FRI')
    set(lent_begin:icp(33), 'LENT_WEEK5_SAT')
    set(lent_begin:icp(34), 'LENT_SUN5')
    set(lent_begin:icp(35), 'LENT_WEEK6_MON')
    set(lent_begin:icp(36), 'LENT_WEEK6_TUE')
    set(lent_begin:icp(37), 'LENT_WEEK6_WED')
    set(lent_begin:icp(38), 'LENT_WEEK6_THU')
    set(lent_begin:icp(39), 'LENT_WEEK6_FRI')
    set(lent_begin:icp(40), 'LENT_WEEK6_SAT')
    set(palm_sun, 'LENT_SUN7')
    set(palm_sun:icp(1), 'LENT_WEEK7_MON')
    set(palm_sun:icp(2), 'LENT_WEEK7_TUE')
    set(palm_sun:icp(3), 'LENT_WEEK7_WED')
    set(palm_sun:icp(4), 'LENT_WEEK7_THU')
    set(palm_sun:icp(5), 'LENT_WEEK7_FRI')
    set(palm_sun:icp(6), 'LENT_WEEK7_SAT')
    set(pasha, 'EASTER')
    set(pasha:icp(1), 'BRIGHT_MON')
    set(pasha:icp(2), 'BRIGHT_TUE')
    set(pasha:icp(3), 'BRIGHT_WED')
    set(pasha:icp(4), 'BRIGHT_THU')
    set(pasha:icp(5), 'BRIGHT_FRI')
    set(pasha:icp(6), 'BRIGHT_SAT')
    set(pasha:icp(7), 'SUN2_AFTER_EASTER')
    set(pasha:icp(8), 'WEEK2_AFTER_EASTER_MON')
    set(pasha:icp(9), 'WEEK2_AFTER_EASTER_TUE')
    set(pasha:icp(10), 'WEEK2_AFTER_EASTER_WED')
    set(pasha:icp(11), 'WEEK2_AFTER_EASTER_THU')
    set(pasha:icp(12), 'WEEK2_AFTER_EASTER_FRI')
    set(pasha:icp(13), 'WEEK2_AFTER_EASTER_SAT')
    set(pasha:icp(14), 'SUN3_AFTER_EASTER')
    set(pasha:icp(15), 'WEEK3_AFTER_EASTER_MON')
    set(pasha:icp(16), 'WEEK3_AFTER_EASTER_TUE')
    set(pasha:icp(17), 'WEEK3_AFTER_EASTER_WED')
    set(pasha:icp(18), 'WEEK3_AFTER_EASTER_THU')
    set(pasha:icp(19), 'WEEK3_AFTER_EASTER_FRI')
    set(pasha:icp(20), 'WEEK3_AFTER_EASTER_SAT')
    set(pasha:icp(21), 'SUN4_AFTER_EASTER')
    set(pasha:icp(22), 'WEEK4_AFTER_EASTER_MON')
    set(pasha:icp(23), 'WEEK4_AFTER_EASTER_TUE')
    set(pasha:icp(24), 'WEEK4_AFTER_EASTER_WED')
    set(pasha:icp(25), 'WEEK4_AFTER_EASTER_THU')
    set(pasha:icp(26), 'WEEK4_AFTER_EASTER_FRI')
    set(pasha:icp(27), 'WEEK4_AFTER_EASTER_SAT')
    set(pasha:icp(28), 'SUN5_AFTER_EASTER')
    set(pasha:icp(29), 'WEEK5_AFTER_EASTER_MON')
    set(pasha:icp(30), 'WEEK5_AFTER_EASTER_TUE')
    set(pasha:icp(31), 'WEEK5_AFTER_EASTER_WED')
    set(pasha:icp(32), 'WEEK5_AFTER_EASTER_THU')
    set(pasha:icp(33), 'WEEK5_AFTER_EASTER_FRI')
    set(pasha:icp(34), 'WEEK5_AFTER_EASTER_SAT')
    set(pasha:icp(35), 'SUN6_AFTER_EASTER')
    set(pasha:icp(36), 'WEEK6_AFTER_EASTER_MON')
    set(pasha:icp(37), 'WEEK6_AFTER_EASTER_TUE')
    set(pasha:icp(38), 'WEEK6_AFTER_EASTER_WED')
    set(ascension, 'WEEK6_AFTER_EASTER_THU')
    set(ascension:icp(1), 'WEEK6_AFTER_EASTER_FRI')
    set(ascension:icp(2), 'WEEK6_AFTER_EASTER_SAT')
    set(ascension:icp(3), 'SUN7_AFTER_EASTER')
    set(ascension:icp(4), 'WEEK7_AFTER_EASTER_MON')
    set(ascension:icp(5), 'WEEK7_AFTER_EASTER_TUE')
    set(ascension:icp(6), 'WEEK7_AFTER_EASTER_WED')
    set(ascension:icp(7), 'WEEK7_AFTER_EASTER_THU')
    set(ascension:icp(8), 'WEEK7_AFTER_EASTER_FRI')
    set(ascension:icp(9), 'WEEK7_AFTER_EASTER_SAT')
    set(pentecost, 'PENTECOST_SUN')
    set(pentecost:icp(1), 'PENTECOST_MON')
    set(pentecost:icp(2), 'PENTECOST_TUE')
    set(pentecost:icp(3), 'PENTECOST_WED')
    set(pentecost:icp(4), 'PENTECOST_THU')
    set(pentecost:icp(5), 'PENTECOST_FRI')
    set(pentecost:icp(6), 'PENTECOST_SAT')
    set(all_saints, 'SUN1_AFTER_PENTECOST')
    set(all_saints:icp(7), 'SUN2_AFTER_PENTECOST')
    set(all_saints:icp(14), 'SUN3_AFTER_PENTECOST')
    set(all_saints:icp(21), 'SUN4_AFTER_PENTECOST')
    -- Суббота перед Воздви́жение
    dd:assign{9,13}:set_to_wd_before(6)
    set(dd, 'SAT_BEFORE_EXALTATION')
    -- неделя перед Воздви́жение
    dd:assign{9,13}:set_to_wd_before(0)
    set(dd, 'SUN_BEFORE_EXALTATION')
    -- Суббота после Воздви́жение
    dd:assign{9,15}:set_to_wd_after(6)
    set(dd, 'SAT_AFTER_EXALTATION')
    -- неделя после Воздви́жение
    dd:assign{9,15}:set_to_wd_after(0)
    set(dd, 'SUN_AFTER_EXALTATION')
    --  Собор новомучеников и исповедников Церкви Русской
    dd:assign{1,25}
    i = dd:wd();
    if i==0 then set(dd, 'NEW_MARTYRS_OF_RUSSIA')
    elseif i==1 or i==2 or i==3 then set(dd:dcp(i), 'NEW_MARTYRS_OF_RUSSIA')
    elseif i==4 or i==5 or i==6 then set(dd:icp(7-i), 'NEW_MARTYRS_OF_RUSSIA')
    end
    --  Память святых отцов VII Вселенского Собора.
    dd:assign{10,11}
    i = dd:wd();
    if i==0 then set(dd, 'FATHERS_ECU_COUNCIL_7')
    elseif i==1 or i==2 or i==3 then set(dd:dcp(i), 'FATHERS_ECU_COUNCIL_7')
    elseif i==4 or i==5 or i==6 then set(dd:icp(7-i), 'FATHERS_ECU_COUNCIL_7')
    end
    --  Димитриевская родительская суббота.
    dd:assign{10,25}
    repeat
      if(dd:wd() == 6 and dd.d ~= 22) then
        set(dd, 'DIMITRI_SAT')
        break;
      end
      dd:D()
    until false
    -- нед.св.отец перед рождеством от 18до24 дек.
    dd:assign{12,24}:set_to_wd_before(0)
    set(dd, 'SUN_BEFORE_CHRISTMAS')
    -- неделя св.праотец от11до17 дек.
    dd:D():set_to_wd_before(0)
    set(dd, 'HOLY_FOREFATHERS_SUN')
    --  Суббота перед рождеством
    dd:assign{12,24}:set_to_wd_before(6)
    set(dd, 'SAT_BEFORE_CHRISTMAS')
    --  Суббота по Рождестве (типикон стр.380)
    dd:assign{12,25}
    i = dd:wd()
    if i==1 then dd:assign{12,30}
    elseif i==2 then dd:assign{12,29}
    elseif i==3 then dd:assign{12,28}
    elseif i==4 then dd:assign{12,27}
    elseif i==5 then dd:assign{12,26}
    else dd:assign{12,31} end
    if ( dd:wd() == 6 ) then set(dd, 'SAT_AFTER_CHRISTMAS')
    else set(dd, 'SAT_AFTER_CHRISTMAS_READINGS') end
    --  Неделя по Рождестве Христовом
    if i==1 then dd:assign{12,31}
    elseif i==2 then dd:assign{12,30}
    elseif i==3 then dd:assign{12,29}
    elseif i==4 then dd:assign{12,28}
    elseif i==5 then dd:assign{12,27}
    else dd:assign{12,26} end
    if ( dd:wd() == 0 ) then set(dd, 'SUN_AFTER_CHRISTMAS')
    else set(dd, 'SUN_AFTER_CHRISTMAS_READINGS') end
    set(dd, 'SAINTS_JOSEPH_DAVID_JAMES')
    --  Суббота пред Богоявлением (типикон стр.380)
    if(i==0 or i==1) then
      if (i == 1) then dd:assign{12,30} else dd:assign{12,31} end
      set(dd, 'SAT_BEFORE_BAPTISM')
    end
    i = year-1
    if i==0 then i = INDICTION_LENGTH end
    dd:assign{i,12,25}
    i = dd:wd()
    if(not(i==0 or i==1)) then
      if i==2 then dd:assign{year,1,5}
      elseif i==3 then dd:assign{year,1,4}
      elseif i==4 then dd:assign{year,1,3}
      elseif i==5 then dd:assign{year,1,2}
      else dd:assign{year,1,1} end
      set(dd, 'SAT_BEFORE_BAPTISM')
    end
    --  неделя пред Богоявлением (типикон стр.380)
    if i==3 then dd:assign{year,1,5}
    elseif i==4 then dd:assign{year,1,4}
    elseif i==5 then dd:assign{year,1,3}
    elseif i==6 then dd:assign{year,1,2}
    else dd:assign{year,1,1} end
    if (dd:wd() == 0) then set(dd, 'SUN_BEFORE_BAPTISM')
    else set(dd, 'SUN_BEFORE_BAPTISM_READINGS') end
    -- Суббота пo Богоявление
    dd:assign{1,7}:set_to_wd_after(6)
    set(dd, 'SAT_AFTER_BAPTISM')
    -- неделя пo Богоявление
    dd:assign{1,7}:set_to_wd_after(0)
    set(dd, 'SUN_AFTER_BAPTISM')
    -- Собор 3-x свят. Василия Великого, Григория Богослова и Иоанна Златоустого.
    dd:assign{1,30}
    if(dd==memorial_sat or dd==dread_judgement:icp(3) or dd==dread_judgement:icp(5)) then dd:D() end
    set(dd, 'CONVENTION_OF_3_HIERARCHS')
    --  Первое и второе Обре́тение главы Иоанна Предтечи
    dd:assign{2,24}
    if( dd == memorial_sat or
        dd == dread_judgement:icp(3) or
        dd == dread_judgement:icp(5) or
        dd == lent_begin ) then dd:D() end
    if(dd>=lent_begin:icp(1) and dd<=lent_begin:icp(4)) then dd = lent_begin:icp(5); end
    set(dd, 'JOHN_BAPTIST_HEAD_DISCOVERY_1_2')
    --  Третье обре́тение главы Предтечи и Крестителя Господня Иоанна
    dd:assign{5,25}
    if( dd==all_saints or dd==pentecost:dcp(1) ) then dd:assign{5,23} end
    if( dd==pentecost:icp(1) ) then dd:assign{5,26} end
    if( dd==pentecost ) then dd:assign{5,22} end
    set(dd, 'JOHN_BAPTIST_HEAD_DISCOVERY_3')
    --  Святых сорока́ мучеников, в Севастийском е́зере мучившихся.
    dd:assign{3,9}
    if(dd==lent_begin:icp(23)) then dd:assign{3,8} end
    if(dd==lent_begin:icp(31)) then dd:assign{3,7} end
    if(dd==lent_begin:icp(33)) then dd:assign{3,10} end
    if(dd>=lent_begin and dd<=lent_begin:icp(4)) then dd = lent_begin:icp(5); end
    set(dd, 'HOLY_FORTY_MARTYRS_OF_SEBASTE')
    --  Предпразднство Благовещения Пресвятой Богородицы.
    dd:assign{3,24}
    t1 = palm_sun:icp(1)
    t2:assign{3,25}
    if(t2<t1) then
      if(dd==palm_sun:dcp(1)) then dd:assign{3,22} end
      if(dd==lent_begin:icp(31)) then dd:assign{3,23} end
      if(dd==lent_begin:icp(29)) then dd:assign{3,23} end
      set(dd, 'FOREFEAST_GOD_MOTHER_ANNUNCIATION')
    end
    -- отдание праздника Благовещ́ение
    dd:assign{3,26}
    t1 = palm_sun:dcp(1);
    if(dd<t1) then
      set(dd, 'ENDOF_GOD_MOTHER_ANNUNCIATION')
    end
    -- Вмч. Гео́ргия Победоно́сца. Мц. царицы Александры
    dd:assign{4,23}
    t1 = palm_sun:icp(1);
    t2 = pasha;
    if(dd>=t1 and dd<=t2) then dd = pasha:icp(1); end
    set(dd, 'HOLY_GREAT_MARTYR_GEORGE')
    -- Святых отец 6-и вселенских соборов
    dd:assign{7,16}
    i = dd:wd()
    if i==0 then set(dd, 'FATHERS_ECU_COUNCIL_1_6')
    elseif i==1 or i==2 or i==3 then
      set(dd:set_to_wd_before(0), 'FATHERS_ECU_COUNCIL_1_6')
    elseif i==4 or i==5 or i==6 then
      set(dd:set_to_wd_after(0), 'FATHERS_ECU_COUNCIL_1_6')
    end
    -- ...

    --  сплошные седмицы
    set(dd(year,1,1),   'SOLID_WEEK_CHRISTMAS');
    set(dd(year,1,2),   'SOLID_WEEK_CHRISTMAS');
    set(dd(year,1,3),   'SOLID_WEEK_CHRISTMAS');
    set(dd(year,1,4),   'SOLID_WEEK_CHRISTMAS');
    set(dd(year,12,25), 'SOLID_WEEK_CHRISTMAS');
    set(dd(year,12,26), 'SOLID_WEEK_CHRISTMAS');
    set(dd(year,12,27), 'SOLID_WEEK_CHRISTMAS');
    set(dd(year,12,28), 'SOLID_WEEK_CHRISTMAS');
    set(dd(year,12,29), 'SOLID_WEEK_CHRISTMAS');
    set(dd(year,12,30), 'SOLID_WEEK_CHRISTMAS');
    set(dd(year,12,31), 'SOLID_WEEK_CHRISTMAS');
    set(pasha,        'SOLID_WEEK_BRIGHT')
    set(pasha:icp(1), 'SOLID_WEEK_BRIGHT')
    set(pasha:icp(2), 'SOLID_WEEK_BRIGHT')
    set(pasha:icp(3), 'SOLID_WEEK_BRIGHT')
    set(pasha:icp(4), 'SOLID_WEEK_BRIGHT')
    set(pasha:icp(5), 'SOLID_WEEK_BRIGHT')
    set(pasha:icp(6), 'SOLID_WEEK_BRIGHT')
    set(pentecost,        'SOLID_WEEK_PENTECOST')
    set(pentecost:icp(1), 'SOLID_WEEK_PENTECOST')
    set(pentecost:icp(2), 'SOLID_WEEK_PENTECOST')
    set(pentecost:icp(3), 'SOLID_WEEK_PENTECOST')
    set(pentecost:icp(4), 'SOLID_WEEK_PENTECOST')
    set(pentecost:icp(5), 'SOLID_WEEK_PENTECOST')
    set(pentecost:icp(6), 'SOLID_WEEK_PENTECOST')
    set(dread_judgement:icp(1), 'SOLID_WEEK_CHEESE')
    set(dread_judgement:icp(2), 'SOLID_WEEK_CHEESE')
    set(dread_judgement:icp(3), 'SOLID_WEEK_CHEESE')
    set(dread_judgement:icp(4), 'SOLID_WEEK_CHEESE')
    set(dread_judgement:icp(5), 'SOLID_WEEK_CHEESE')
    set(dread_judgement:icp(6), 'SOLID_WEEK_CHEESE')
    set(dread_judgement:icp(7), 'SOLID_WEEK_CHEESE')
    set(publican_pharisee,        'SOLID_WEEK_PUBLICAN_PHARISEE')
    set(publican_pharisee:icp(1), 'SOLID_WEEK_PUBLICAN_PHARISEE')
    set(publican_pharisee:icp(2), 'SOLID_WEEK_PUBLICAN_PHARISEE')
    set(publican_pharisee:icp(3), 'SOLID_WEEK_PUBLICAN_PHARISEE')
    set(publican_pharisee:icp(4), 'SOLID_WEEK_PUBLICAN_PHARISEE')
    set(publican_pharisee:icp(5), 'SOLID_WEEK_PUBLICAN_PHARISEE')
    set(publican_pharisee:icp(6), 'SOLID_WEEK_PUBLICAN_PHARISEE')
    --  посты
    dd:assign{year,8,1}
    t1:assign{year,8,15}
    while dd<t1 do
      set(dd, 'ASSUMPTION_LENT')
      dd:i()
    end
    dd:assign{year,11,15}
    t1:assign{year,12,25}
    while dd<t1 do
      set(dd, 'CHRISTMAS_LENT')
      dd:i()
    end
    dd = all_saints:icp(1)
    t1:assign{year,6,29}
    while dd<t1 do
      set(dd, 'APOSTOL_LENT')
      dd:i()
    end
    dd = lent_begin
    while dd<pasha do
      set(dd, 'GREAT_LENT')
      dd:i()
    end
    --  один из трех типов церковных праздников
    set(palm_sun,      'MOVEABLE_FEAST')
    set(ascension,     'MOVEABLE_FEAST')
    set(pentecost,     'MOVEABLE_FEAST')
    set(dd(year,1,6),  'IMMOVEABLE_FEAST');
    set(god_meeting,   'IMMOVEABLE_FEAST')
    set(dd(year,3,25), 'IMMOVEABLE_FEAST');
    set(dd(year,8,6),  'IMMOVEABLE_FEAST');
    set(dd(year,8,15), 'IMMOVEABLE_FEAST');
    set(dd(year,9,8),  'IMMOVEABLE_FEAST');
    set(dd(year,9,14), 'IMMOVEABLE_FEAST');
    set(dd(year,11,21),'IMMOVEABLE_FEAST');
    set(dd(year,12,25),'IMMOVEABLE_FEAST');
    set(dd(year,1,1),  'GREAT_FEAST');
    set(dd(year,6,24), 'GREAT_FEAST');
    set(dd(year,6,29), 'GREAT_FEAST');
    set(dd(year,8,29), 'GREAT_FEAST');
    set(dd(year,10,1), 'GREAT_FEAST');
  end -- fill 'array_of_dates_by_property_and_year' loop

  -- create array of "PROPERTY_NAME" keys & check values
  array_of_dates_by_property_and_year_keys = {}
  for k in pairs(array_of_dates_by_property_and_year) do
    array_of_dates_by_property_and_year_keys[#array_of_dates_by_property_and_year_keys + 1] = k
    if DAY_PROPERTIES[k] == nil then
      error("index '" .. k .. "' not found in 'DAY_PROPERTIES' array")
    end
  end
  for k in pairs(DAY_PROPERTIES) do
    if array_of_dates_by_property_and_year[k] == nil then
      error("index '" .. k .. "' not found in 'array_of_dates_by_property_and_year'")
    end
  end
  -- sort "PROPERTY_NAME" keys
  table.sort(
    array_of_dates_by_property_and_year_keys,
    function(a,b) return DAY_PROPERTIES[a] < DAY_PROPERTIES[b] end
  )
  -- save results
  local P_COUNT = #DAY_PROPERTIES_
  local BS = "BS"..(MAX_DATES_COUNT*9)
  out2:write("using ", BS, " = std::bitset<", (MAX_DATES_COUNT*9), "> ;\n")
  out2:write("constexpr std::array array_of_dates_by_property_and_year = {\n")
  for p = 1, P_COUNT do
    out2:write('  std::array{\n')
    for y = 1, INDICTION_LENGTH do
      local t = {'    ', BS, '{ "'}
      local dates = array_of_dates_by_property_and_year[ DAY_PROPERTIES_[p][1] ][ y ]
      for i = 1, MAX_DATES_COUNT do
        if dates[i]~=nil then t[#t + 1] = to_binary_str(dates[i].m, 4) .. to_binary_str(dates[i].d, 5)
        else t[#t + 1] = to_binary_str(0,9) end
      end
      t[#t + 1] = '" },'
      out2:write(table.concat(t), '\n')
    end
    out2:write("  },\n")
  end
  out2:write("};\n")
  local c2 = [[
} // namespace without name

namespace full_indiction {

MonthDay find_date(const int y, const DayProperty p)
{
  check_year_number(y) ;
  check_property_number(p) ;
  const auto& b = array_of_dates_by_property_and_year[static_cast<int>(p)][y-1];
  std::bitset<9> m;
  for (int k = m.size() - 1, i = b.size() - 1; k>=0; --k, --i) m[k] = b[i] ;
  auto d = m;
  m >>= 5;
  d &= 0b11111u ;
  return { m.to_ulong(), d.to_ulong() };
}

std::vector<MonthDay> find_all_dates(const int y, const DayProperty p)
{
  check_year_number(y) ;
  check_property_number(p) ;
  std::vector<MonthDay> result;
  std::vector<std::bitset<9>> vb;
  const auto& b = array_of_dates_by_property_and_year[static_cast<int>(p)][y-1];
  std::string s(b.size(), '0');
  for (int k = b.size() - 1, i = 0; k>=0; --k, ++i) if (b[k]) s[i] = '1';
  for (auto i = 0u; i<s.size(); i+=9) {
    auto q = s.substr(i, 9) ;
    if ( std::any_of(q.begin(), q.end(), [](char c){ return c=='1'; }) ) vb.emplace_back(q) ;
  }
  std::transform(vb.begin(), vb.end(), std::back_inserter(result), [](const auto& e){
    auto m = e, d = e;
    m >>= 5;
    d &= 0b11111u;
    return MonthDay { m.to_ulong(), d.to_ulong() };
  });
  return result;
}

std::vector<MonthDay> find_all_dates(const int y, std::initializer_list<DayProperty> il)
{
  std::vector<MonthDay> result;
  for (auto p: il) {
    auto v = find_all_dates(y,p);
    std::move(v.begin(), v.end(), std::back_inserter(result));
  }
  return result;
}

MonthDay easter_date(const int y)
{
  return find_date(y, PASHA);
}

bool is_date_of(const int y, const MonthDay d, const DayProperty p)
{
  check_date(y, d);
  return d == find_date(y, p);
}

int apostol_fast_length(const int y)
{
  check_year_number(y) ;
  const bool leap = is_leap(y) ;
  int x1 = 0;
  int x2 = leap ? 181 : 180 ;
  auto pasha = easter_date(y);
  for (int i=1; i<pasha.first; ++i) x1 += month_length(i, leap) ;
  x1 += pasha.second ;
  return x2 - x1 - 57 ;
}

} // namespace full_indiction ]]
  out2:write(c2, '\n')
  assert(out2:close())
end
