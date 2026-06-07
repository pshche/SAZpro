# Juice Shop

## Компонент	Версия	CVE	CVSS	Решение триажа	VEX justification	Комментарий
crypto-js	3.3.0	CVE-2023-46233	7.5 (High)	Принято (Accept)	vulnerability_not_exploitable – Juice Shop учебное приложение; уязвимая функция не используется в реальных криптооперациях.	Учебный стенд, криптография не применяется в реальных сценариях
lodash	2.4.2	CVE-2019-10744	9.8 (Critical)	Ложное срабатывание (False Positive, Avoid)	false_positive – Сканер определил версию транзитивной зависимости, которая не загружается. Реальная версия lodash 4.17.21 не подвержена уязвимости.	Транзитивная зависимость, не используемая в рантайме
jsonwebtoken	0.4.0	CVE-2015-9235	9.8 (Critical)	Избежание (Avoid)	vulnerable_code_not_in_execute_path – Приложение использует кастомный обработчик токенов, метод verify() библиотеки не вызывается.	Кастомная реализация JWT обходит уязвимый код
moment	2.0.0	CVE-2017-18214	7.5 (High)	Смягчено (Mitigate)	under_investigation – Проводится оценка влияния ReDoS, выясняется, попадают ли недоверенные данные в конструктор moment.	Требуется дополнительный анализ достижимости ReDoS
minimatch	3.0.5	CVE-2026-26996	7.5 (High)	Смягчено (Mitigate)	inline_mitigations_exist – WAF блокирует вредоносные шаблоны, установлены лимиты длины ввода, предотвращающие ReDoS.	Внешние компенсирующие меры (WAF + валидация)
moment	2.0.0	CVE-2022-24785	7.5 (High)	Принято (Accept)	vulnerability_not_exploitable – Функция переключения локалей по пользовательскому вводу не используется; все даты форматируются фиксированно.	Уязвимый функционал не востребован в приложении


# WebGoat

## Компонент	Версия	CVE	CVSS	Решение триажа	VEX justification	Комментарий
org.thymeleaf:thymeleaf	3.1.2.RELEASE	CVE-2026-41901	9.8 (Critical)	Принято (Accept)	vulnerability_not_exploitable – WebGoat учебное приложение; Thymeleaf используется только для отрисовки шаблонов уроков и не обрабатывает недоверенные входные данные.	Учебное приложение, нет недоверенного ввода в шаблонизатор
org.apache.tomcat.embed:tomcat-embed-core	10.x	CVE-2026-43512	9.8 (Critical)	Избежание (Avoid)	vulnerable_code_not_in_execute_path – Встроенный Tomcat слушает только на localhost и никогда не используется в production-окружении.	Сервер слушает только локальный интерфейс
org.springframework.security:spring-security…	уязвимая	CVE-2025-41232	9.1 (Critical)	Смягчено (Mitigate)	inline_mitigations_exist – Дополнительный кастомный фильтр безопасности блокирует попытки эксплуатации до Spring Security.	Дополнительный фильтр нейтрализует вектор атаки
com.thoughtworks.xstream:xstream	1.4.5	CVE-2013-7285	9.8 (Critical)	Смягчено (Mitigate)	under_investigation – Уязвимость в XStream используется только в одном уроке; проводится оценка, попадают ли недоверенные данные в парсер.	Ограниченное использование, анализ продолжается
com.thoughtworks.xstream:xstream	1.4.5	CVE-2021-39148	7.5 (High)	Принято (Accept)	vulnerability_not_exploitable – Уязвимость XStream присутствует в намеренно уязвимом уроке. Риск принят как часть образовательного сценария.	Является частью учебного задания
org.springframework.security:spring-security…	уязвимая	CVE-2026-22732	7.4 (High)	Ложное срабатывание (False Positive, Avoid)	false_positive – Уязвимость требует устаревшей функции, не включённой в конфигурации WebGoat.	Условия уязвимости отсутствуют в конфигурации