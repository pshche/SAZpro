

## Таблица 1. По CVE в образах (пример для Juice Shop)

Образ	CVE	Severity	Пакет	Версия	Fixed in	True / False Positive	Комментарий
juice-shop	CVE-2023-46233	HIGH	crypto-js	3.3.0	3.3.1	True Positive	Учебное приложение, уязвимость присутствует намеренно
juice-shop	CVE-2019-10744	CRITICAL	lodash	2.4.2	4.17.21	False Positive	Транзитивная зависимость, реальная версия lodash не уязвима
webgoat	CVE-2026-41901	CRITICAL	thymeleaf	3.1.2.RELEASE	?	True Positive	Учебное приложение, используется только для шаблонов уроков
## Таблица 2. По мисконфигам IaC (из targets/iac-demo)
Файл	Rule ID	Severity	Описание	Решение
Dockerfile	DS001	HIGH	Устаревший базовый образ ubuntu:18.04	Исправить на ubuntu:22.04 или новее
Dockerfile	DS002	HIGH	Запуск контейнера от root	Использовать USER с непривилегированным пользователем
Dockerfile	DS013	MEDIUM	Использование ADD для удалённого URL	Заменить на COPY или RUN curl

## Таблица 3. По мисконфигам IaC (из targets/iac-demo)
Название (Alert)	WASC ID / CWE	Risk	Confidence	URL/Параметр	Request (фрагмент)	Response (фрагмент)	True / False Positive	Корреляция с SAST
SQL Injection	WASC-19 / CWE-89	High	High	http://localhost:3000/rest/products/search?q=%27%28	GET /rest/products/search?q=%27%28	HTTP/1.1 500 Internal Server Error	True Positive	Совпадает с находкой Semgrep "Detected User Input Used to Manually Construct a SQL String" (CWE-89)
Backup File Disclosure	WASC-34 / CWE-530	Medium	High	http://localhost:3000/ftp/quarantine%20-%20Copy	GET /ftp/quarantine%20-%20Copy	Обнаружены резервные копии файлов (quarantine - Copy, quarantine.bac, quarantine.backup)	True Positive	Вне зоны видимости SAST (проблема конфигурации веб-сервера)
Content Security Policy (CSP) Header Not Set	WASC-15 / CWE-693	Medium	High	http://localhost:3000	GET /	Отсутствует заголовок Content-Security-Policy	True Positive	SAST не анализирует заголовки ответа (DAST-only)
Cross-Domain Misconfiguration	WASC-14 / CWE-264	Medium	High	http://localhost:3000	GET /	Access-Control-Allow-Origin: *	True Positive	Контроль заголовков безопасности — задача DAST
Session ID in URL Rewrite	WASC-13 / CWE-598	Medium	High	http://localhost:3000/socket.io/?EIO=4&transport=polling&sid=...	GET /socket.io/?EIO=4&transport=polling&sid=...	Параметр sid передаётся в URL (например, nnvG-jZnYstsM_FAAAAO)	True Positive	Динамическая особенность Socket.IO, не выявляется статическим анализом
HTTP Only Site	WASC-4 / CWE-311	Medium	High	http://localhost:3000/socket.io/?EIO=4&transport=polling&t=PwSwuLa	GET /socket.io/?EIO=4&transport=polling&t=PwSwuLa	Попытка подключения через HTTPS не удалась, сайт работает только по HTTP	True Positive	SAST не применим — проверка протокола передачи данных
Missing Anti-clickjacking Header	WASC-15 / CWE-1021	Medium	High	http://localhost:3000/socket.io/?EIO=4&transport=polling&t=PwSwlRq&sid=...	POST /socket.io/...	Отсутствуют заголовки X-Frame-Options или Content-Security-Policy frame-ancestors	True Positive	Отсутствует в SAST-результатах — проверка защитных заголовков относится к DAST
Private IP Disclosure	WASC-13 / CWE-497	Low	High	http://localhost:3000/rest/admin/application-configuration	GET /rest/admin/application-configuration	В теле ответа обнаружен приватный IP: 192.168.99.100:3000	True Positive	SAST не покрывает динамическое раскрытие информации




### доп информация по триажу
Report Summary

┌────────────┬────────────┬───────────────────┐
│   Target   │    Type    │ Misconfigurations │
├────────────┼────────────┼───────────────────┤
│ Dockerfile │ dockerfile │         3         │
└────────────┴────────────┴───────────────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)
Dockerfile (dockerfile)

Tests: 27 (SUCCESSES: 24, FAILURES: 3)
Failures: 3 (UNKNOWN: 0, LOW: 1, MEDIUM: 1, HIGH: 1, CRITICAL: 0)

DS-0002 (HIGH): Last USER command in Dockerfile should not be 'root'
═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Running containers with 'root' user can lead to a container escape situation. It is a best practice to run containers as non-root users, which can be done by adding a 'USER' statement to the Dockerfile.

See https://avd.aquasec.com/misconfig/ds-0002
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
 Dockerfile:2
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   2 [ USER root
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
DS-0004 (MEDIUM): Port 22 should not be exposed in Dockerfile
═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Exposing port 22 might allow users to SSH into the container.

See https://avd.aquasec.com/misconfig/ds-0004
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
 Dockerfile:5
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   5 [ EXPOSE 22
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
DS-0026 (LOW): Add HEALTHCHECK instruction in your Dockerfile
═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
You should add HEALTHCHECK instruction in your docker container images to perform the health check on running containers.

See https://avd.aquasec.com/misconfig/ds-0026
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

ps@MacBook-Pro-Pavel sca % trivy image --format json --severity HIGH,CRITICAL --skip-db-update bkimminich/juice-shop |
  jq -r '
    ["FILE/TARGET","CVE","PACKAGE","INSTALLED","SEVERITY"],
    (.Results[]? |
     .Target as $target |
     .Vulnerabilities[]? |
     select(.Severity == "HIGH" or .Severity == "CRITICAL") |
     [$target, .VulnerabilityID, .PkgName, .InstalledVersion, .Severity]) |
    @tsv
  ' | column -t -s $'\t'
2026-06-06T10:58:40+03:00	INFO	[vuln] Vulnerability scanning is enabled
2026-06-06T10:58:40+03:00	INFO	[secret] Secret scanning is enabled
2026-06-06T10:58:40+03:00	INFO	[secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2026-06-06T10:58:40+03:00	INFO	[secret] Please see https://trivy.dev/docs/v0.71/guide/scanner/secret#recommendation for faster secret detection
2026-06-06T10:58:40+03:00	INFO	Detected OS	family="debian" version="13.4"
2026-06-06T10:58:40+03:00	INFO	[debian] Detecting vulnerabilities...	os_version="13" pkg_num=13
2026-06-06T10:58:40+03:00	INFO	Number of language-specific files	num=1
2026-06-06T10:58:40+03:00	INFO	[node-pkg] Detecting vulnerabilities...
2026-06-06T10:58:40+03:00	WARN	Using severities from other vendors for some vulnerabilities. Read https://trivy.dev/docs/v0.71/guide/scanner/vulnerability#severity-selection for details.
FILE/TARGET  CVE                  PACKAGE               INSTALLED    SEVERITY
Node.js      NSWG-ECO-428         base64url             0.0.6        HIGH
Node.js      CVE-2023-46233       crypto-js             3.3.0        CRITICAL
Node.js      CVE-2020-15084       express-jwt           0.1.3        HIGH
Node.js      CVE-2022-25881       http-cache-semantics  3.8.1        HIGH
Node.js      CVE-2015-9235        jsonwebtoken          0.1.0        CRITICAL
Node.js      CVE-2022-23539       jsonwebtoken          0.1.0        HIGH
Node.js      NSWG-ECO-17          jsonwebtoken          0.1.0        HIGH
Node.js      CVE-2015-9235        jsonwebtoken          0.4.0        CRITICAL
Node.js      CVE-2022-23539       jsonwebtoken          0.4.0        HIGH
Node.js      NSWG-ECO-17          jsonwebtoken          0.4.0        HIGH
Node.js      CVE-2016-1000223     jws                   0.2.6        HIGH
Node.js      CVE-2025-65945       jws                   0.2.6        HIGH
Node.js      CVE-2019-10744       lodash                2.4.2        CRITICAL
Node.js      CVE-2018-16487       lodash                2.4.2        HIGH
Node.js      CVE-2021-23337       lodash                2.4.2        HIGH
Node.js      CVE-2020-8203        lodash.set            4.3.2        HIGH
Node.js      GHSA-5mrr-rgp6-x4gr  marsdb                0.6.11       CRITICAL
Node.js      CVE-2026-26996       minimatch             3.0.5        HIGH
Node.js      CVE-2026-27903       minimatch             3.0.5        HIGH
Node.js      CVE-2026-27904       minimatch             3.0.5        HIGH
Node.js      CVE-2017-18214       moment                2.0.0        HIGH
Node.js      CVE-2022-24785       moment                2.0.0        HIGH
Node.js      CVE-2025-47935       multer                1.4.5-lts.2  HIGH
Node.js      CVE-2025-47944       multer                1.4.5-lts.2  HIGH
Node.js      CVE-2025-48997       multer                1.4.5-lts.2  HIGH
Node.js      CVE-2025-7338        multer                1.4.5-lts.2  HIGH
Node.js      CVE-2026-2359        multer                1.4.5-lts.2  HIGH
Node.js      CVE-2026-3304        multer                1.4.5-lts.2  HIGH
Node.js      CVE-2026-3520        multer                1.4.5-lts.2  HIGH
Node.js      CVE-2022-25887       sanitize-html         1.4.2        HIGH
Node.js      CVE-2026-33151       socket.io-parser      4.0.5        HIGH
Node.js      CVE-2026-23745       tar                   4.4.19       HIGH
Node.js      CVE-2026-23950       tar                   4.4.19       HIGH
Node.js      CVE-2026-24842       tar                   4.4.19       HIGH
Node.js      CVE-2026-26960       tar                   4.4.19       HIGH
Node.js      CVE-2026-29786       tar                   4.4.19       HIGH
Node.js      CVE-2026-31802       tar                   4.4.19       HIGH
Node.js      CVE-2026-23745       tar                   6.2.1        HIGH
Node.js      CVE-2026-23950       tar                   6.2.1        HIGH
Node.js      CVE-2026-24842       tar                   6.2.1        HIGH
Node.js      CVE-2026-26960       tar                   6.2.1        HIGH
Node.js      CVE-2026-29786       tar                   6.2.1        HIGH
Node.js      CVE-2026-31802       tar                   6.2.1        HIGH
Node.js      CVE-2024-37890       ws                    7.4.6        HIGH
ps@MacBook-Pro-Pavel sca % 

ps@MacBook-Pro-Pavel sca % trivy image --severity HIGH,CRITICAL --skip-db-update bkimminich/juice-shop 2>/dev/null | grep -vE "│\s+0\s+│"

Report Summary

┌──────────────────────────────────────────────────────────────────────────────────┬──────────┬─────────────────┬─────────┐
│                                      Target                                      │   Type   │ Vulnerabilities │ Secrets │

│ package.json                                                                     │          │                 │         │

│ juice-shop/node_modules/base64url/package.json                                   │ node-pkg │        1        │    -    │
│ juice-shop/node_modules/crypto-js/package.json                                   │ node-pkg │        1        │    -    │
│ age.json                                                                         │          │                 │         │

│ juice-shop/node_modules/engine.io/node_modules/ws/package.json                   │ node-pkg │        1        │    -    │
│ juice-shop/node_modules/express-jwt/node_modules/jsonwebtoken/package.json       │ node-pkg │        3        │    -    │

│ juice-shop/node_modules/express-jwt/node_modules/moment/package.json             │ node-pkg │        2        │    -    │

│ juice-shop/node_modules/express-jwt/package.json                                 │ node-pkg │        1        │    -    │

│ json                                                                             │          │                 │         │

│ .json                                                                            │          │                 │         │
│ e.json                                                                           │          │                 │         │

│ json                                                                             │          │                 │         │

│ age.json                                                                         │          │                 │         │

│ .json                                                                            │          │                 │         │
│ ge.json                                                                          │          │                 │         │

│ json                                                                             │          │                 │         │

│ on                                                                               │          │                 │         │

│ age.json                                                                         │          │                 │         │

│ juice-shop/node_modules/http-cache-semantics/package.json                        │ node-pkg │        1        │    -    │
│ juice-shop/node_modules/jsonwebtoken/package.json                                │ node-pkg │        3        │    -    │

│ juice-shop/node_modules/jws/package.json                                         │ node-pkg │        2        │    -    │
│ juice-shop/node_modules/lodash.set/package.json                                  │ node-pkg │        1        │    -    │
│ kage.json                                                                        │          │                 │         │
│ juice-shop/node_modules/marsdb/package.json                                      │ node-pkg │        1        │    -    │
│ juice-shop/node_modules/multer/package.json                                      │ node-pkg │        7        │    -    │
│ juice-shop/node_modules/node-pre-gyp/node_modules/tar/package.json               │ node-pkg │        6        │    -    │
│ .json                                                                            │          │                 │         │

│ m/package.json                                                                   │          │                 │         │

│ /package.json                                                                    │          │                 │         │

│ juice-shop/node_modules/replace/node_modules/minimatch/package.json              │ node-pkg │        3        │    -    │
│ age.json                                                                         │          │                 │         │

│ age.json                                                                         │          │                 │         │

│ juice-shop/node_modules/sanitize-html/node_modules/lodash/package.json           │ node-pkg │        3        │    -    │

│ juice-shop/node_modules/sanitize-html/package.json                               │ node-pkg │        1        │    -    │
│ juice-shop/node_modules/socket.io-parser/package.json                            │ node-pkg │        1        │    -    │
│ json                                                                             │          │                 │         │

│ juice-shop/node_modules/sqlite3/node_modules/tar/package.json                    │ node-pkg │        6        │    -    │
│ .json                                                                            │          │                 │         │
│ json                                                                             │          │                 │         │
│ on                                                                               │          │                 │         │

│ /juice-shop/build/lib/insecurity.js                                              │   text   │        -        │    1    │

│ /juice-shop/lib/insecurity.ts                                                    │   text   │        -        │    1    │
└──────────────────────────────────────────────────────────────────────────────────┴──────────┴─────────────────┴─────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)
Node.js (node-pkg)
==================
Total: 44 (HIGH: 39, CRITICAL: 5)

┌─────────────────────────────────────┬─────────────────────┬──────────┬──────────┬───────────────────┬─────────────────────────────────────────────────────────┬──────────────────────────────────────────────────────────────┐
│               Library               │    Vulnerability    │ Severity │  Status  │ Installed Version │                      Fixed Version                      │                            Title                             │
├─────────────────────────────────────┼─────────────────────┼──────────┼──────────┼───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ base64url (package.json)            │ NSWG-ECO-428        │ HIGH     │ fixed    │ 0.0.6             │ >=3.0.0                                                 │ Out-of-bounds Read                                           │
│                                     │                     │          │          │                   │                                                         │ https://hackerone.com/reports/321687                         │
├─────────────────────────────────────┼─────────────────────┼──────────┤          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ crypto-js (package.json)            │ CVE-2023-46233      │ CRITICAL │          │ 3.3.0             │ 4.2.0                                                   │ crypto-js: PBKDF2 1,000 times weaker than specified in 1993  │
│                                     │                     │          │          │                   │                                                         │ and 1.3M times...                                            │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2023-46233                   │
├─────────────────────────────────────┼─────────────────────┼──────────┤          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ express-jwt (package.json)          │ CVE-2020-15084      │ HIGH     │          │ 0.1.3             │ 6.0.0                                                   │ Authorization bypass in express-jwt                          │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2020-15084                   │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ http-cache-semantics (package.json) │ CVE-2022-25881      │          │          │ 3.8.1             │ 4.1.1                                                   │ http-cache-semantics: Regular Expression Denial of Service   │
│                                     │                     │          │          │                   │                                                         │ (ReDoS) vulnerability                                        │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2022-25881                   │
├─────────────────────────────────────┼─────────────────────┼──────────┤          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ jsonwebtoken (package.json)         │ CVE-2015-9235       │ CRITICAL │          │ 0.1.0             │ 4.2.2                                                   │ nodejs-jsonwebtoken: verification step bypass with an        │
│                                     │                     │          │          │                   │                                                         │ altered token                                                │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2015-9235                    │
│                                     ├─────────────────────┼──────────┤          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2022-23539      │ HIGH     │          │                   │ 9.0.0                                                   │ jsonwebtoken: Unrestricted key type could lead to legacy     │
│                                     │                     │          │          │                   │                                                         │ keys usagen                                                  │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2022-23539                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ NSWG-ECO-17         │          │          │                   │ >=4.2.2                                                 │ Verification Bypass                                          │
│                                     ├─────────────────────┼──────────┤          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2015-9235       │ CRITICAL │          │ 0.4.0             │ 4.2.2                                                   │ nodejs-jsonwebtoken: verification step bypass with an        │
│                                     │                     │          │          │                   │                                                         │ altered token                                                │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2015-9235                    │
│                                     ├─────────────────────┼──────────┤          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2022-23539      │ HIGH     │          │                   │ 9.0.0                                                   │ jsonwebtoken: Unrestricted key type could lead to legacy     │
│                                     │                     │          │          │                   │                                                         │ keys usagen                                                  │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2022-23539                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ NSWG-ECO-17         │          │          │                   │ >=4.2.2                                                 │ Verification Bypass                                          │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ jws (package.json)                  │ CVE-2016-1000223    │          │          │ 0.2.6             │ >=3.0.0                                                 │ Forgeable Public/Private Tokens                              │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2016-1000223                 │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2025-65945      │          │          │                   │ 3.2.3, 4.0.1                                            │ node-jws: auth0/node-jws: Improper signature verification in │
│                                     │                     │          │          │                   │                                                         │ HS256 algorithm                                              │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2025-65945                   │
├─────────────────────────────────────┼─────────────────────┼──────────┤          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ lodash (package.json)               │ CVE-2019-10744      │ CRITICAL │          │ 2.4.2             │ 4.17.12                                                 │ nodejs-lodash: prototype pollution in defaultsDeep function  │
│                                     │                     │          │          │                   │                                                         │ leading to modifying properties                              │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2019-10744                   │
│                                     ├─────────────────────┼──────────┤          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2018-16487      │ HIGH     │          │                   │ >=4.17.11                                               │ lodash: Prototype pollution in utilities function            │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2018-16487                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2021-23337      │          │          │                   │ 4.17.21                                                 │ nodejs-lodash: command injection via template                │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2021-23337                   │
├─────────────────────────────────────┼─────────────────────┤          ├──────────┼───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ lodash.set (package.json)           │ CVE-2020-8203       │          │ affected │ 4.3.2             │                                                         │ nodejs-lodash: prototype pollution in zipObjectDeep function │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2020-8203                    │
├─────────────────────────────────────┼─────────────────────┼──────────┤          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ marsdb (package.json)               │ GHSA-5mrr-rgp6-x4gr │ CRITICAL │          │ 0.6.11            │                                                         │ Command Injection in marsdb                                  │
│                                     │                     │          │          │                   │                                                         │ https://github.com/advisories/GHSA-5mrr-rgp6-x4gr            │
├─────────────────────────────────────┼─────────────────────┼──────────┼──────────┼───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ minimatch (package.json)            │ CVE-2026-26996      │ HIGH     │ fixed    │ 3.0.5             │ 10.2.1, 9.0.6, 8.0.5, 7.4.7, 6.2.1, 5.1.7, 4.2.4, 3.1.3 │ minimatch: minimatch: Denial of Service via specially        │
│                                     │                     │          │          │                   │                                                         │ crafted glob patterns                                        │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-26996                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-27903      │          │          │                   │ 10.2.3, 9.0.7, 8.0.6, 7.4.8, 6.2.2, 5.1.8, 4.2.5, 3.1.3 │ minimatch: minimatch: Denial of Service due to unbounded     │
│                                     │                     │          │          │                   │                                                         │ recursive backtracking via crafted...                        │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-27903                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-27904      │          │          │                   │ 10.2.3, 9.0.7, 8.0.6, 7.4.8, 6.2.2, 5.1.8, 4.2.5, 3.1.4 │ minimatch: Minimatch: Denial of Service via catastrophic     │
│                                     │                     │          │          │                   │                                                         │ backtracking in glob expressions                             │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-27904                   │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ moment (package.json)               │ CVE-2017-18214      │          │          │ 2.0.0             │ 2.19.3                                                  │ nodejs-moment: Regular expression denial of service          │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2017-18214                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2022-24785      │          │          │                   │ 2.29.2                                                  │ Moment.js: Path traversal in moment.locale                   │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2022-24785                   │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ multer (package.json)               │ CVE-2025-47935      │          │          │ 1.4.5-lts.2       │ 2.0.0                                                   │ Multer vulnerable to Denial of Service via memory leaks from │
│                                     │                     │          │          │                   │                                                         │ unclosed streams...                                          │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2025-47935                   │
│                                     ├─────────────────────┤          │          │                   │                                                         ├──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2025-47944      │          │          │                   │                                                         │ Multer vulnerable to Denial of Service from maliciously      │
│                                     │                     │          │          │                   │                                                         │ crafted requests                                             │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2025-47944                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2025-48997      │          │          │                   │ 2.0.1                                                   │ multer: Multer vulnerable to Denial of Service via unhandled │
│                                     │                     │          │          │                   │                                                         │ exception                                                    │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2025-48997                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2025-7338       │          │          │                   │ 2.0.2                                                   │ multer: Multer Denial of Service                             │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2025-7338                    │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-2359       │          │          │                   │ 2.1.0                                                   │ multer: Multer: Denial of Service via dropped file upload    │
│                                     │                     │          │          │                   │                                                         │ connections                                                  │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-2359                    │
│                                     ├─────────────────────┤          │          │                   │                                                         ├──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-3304       │          │          │                   │                                                         │ multer: Multer: Denial of Service via malformed requests     │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-3304                    │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-3520       │          │          │                   │ 2.1.1                                                   │ multer: Multer: Denial of Service via malformed requests     │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-3520                    │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ sanitize-html (package.json)        │ CVE-2022-25887      │          │          │ 1.4.2             │ 2.7.1                                                   │ sanitize-html: insecure global regular expression            │
│                                     │                     │          │          │                   │                                                         │ replacement logic may lead to ReDoS                          │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2022-25887                   │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ socket.io-parser (package.json)     │ CVE-2026-33151      │          │          │ 4.0.5             │ 3.3.5, 3.4.4, 4.2.6                                     │ socket.io: Socket.IO: Denial of Service due to excessive     │
│                                     │                     │          │          │                   │                                                         │ buffering of specially crafted...                            │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-33151                   │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ tar (package.json)                  │ CVE-2026-23745      │          │          │ 4.4.19            │ 7.5.3                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite and        │
│                                     │                     │          │          │                   │                                                         │ symlink poisoning via unsanitized linkpaths...               │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23745                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-23950      │          │          │                   │ 7.5.4                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite via        │
│                                     │                     │          │          │                   │                                                         │ Unicode path collision race condition...                     │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23950                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-24842      │          │          │                   │ 7.5.7                                                   │ node-tar: tar: node-tar: Arbitrary file creation via path    │
│                                     │                     │          │          │                   │                                                         │ traversal bypass in hardlink...                              │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-24842                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-26960      │          │          │                   │ 7.5.8                                                   │ node-tar: node-tar: Arbitrary file read/write via malicious  │
│                                     │                     │          │          │                   │                                                         │ archive hardlink creation                                    │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-26960                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-29786      │          │          │                   │ 7.5.10                                                  │ node-tar: hardlink path traversal via drive-relative         │
│                                     │                     │          │          │                   │                                                         │ linkpath                                                     │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-29786                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-31802      │          │          │                   │ 7.5.11                                                  │ tar: tar: File overwrite via drive-relative symlink          │
│                                     │                     │          │          │                   │                                                         │ traversal                                                    │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-31802                   │
│                                     ├─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-23745      │          │          │ 6.2.1             │ 7.5.3                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite and        │
│                                     │                     │          │          │                   │                                                         │ symlink poisoning via unsanitized linkpaths...               │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23745                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-23950      │          │          │                   │ 7.5.4                                                   │ node-tar: tar: node-tar: Arbitrary file overwrite via        │
│                                     │                     │          │          │                   │                                                         │ Unicode path collision race condition...                     │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-23950                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-24842      │          │          │                   │ 7.5.7                                                   │ node-tar: tar: node-tar: Arbitrary file creation via path    │
│                                     │                     │          │          │                   │                                                         │ traversal bypass in hardlink...                              │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-24842                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-26960      │          │          │                   │ 7.5.8                                                   │ node-tar: node-tar: Arbitrary file read/write via malicious  │
│                                     │                     │          │          │                   │                                                         │ archive hardlink creation                                    │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-26960                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-29786      │          │          │                   │ 7.5.10                                                  │ node-tar: hardlink path traversal via drive-relative         │
│                                     │                     │          │          │                   │                                                         │ linkpath                                                     │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-29786                   │
│                                     ├─────────────────────┤          │          │                   ├─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│                                     │ CVE-2026-31802      │          │          │                   │ 7.5.11                                                  │ tar: tar: File overwrite via drive-relative symlink          │
│                                     │                     │          │          │                   │                                                         │ traversal                                                    │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2026-31802                   │
├─────────────────────────────────────┼─────────────────────┤          │          ├───────────────────┼─────────────────────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ ws (package.json)                   │ CVE-2024-37890      │          │          │ 7.4.6             │ 5.2.4, 6.2.3, 7.5.10, 8.17.1                            │ nodejs-ws: denial of service when handling a request with    │
│                                     │                     │          │          │                   │                                                         │ many HTTP headers...                                         │
│                                     │                     │          │          │                   │                                                         │ https://avd.aquasec.com/nvd/cve-2024-37890                   │
└─────────────────────────────────────┴─────────────────────┴──────────┴──────────┴───────────────────┴─────────────────────────────────────────────────────────┴──────────────────────────────────────────────────────────────┘

/juice-shop/build/lib/insecurity.js (secrets)
=============================================
Total: 1 (HIGH: 1, CRITICAL: 0)

HIGH: AsymmetricPrivateKey (private-key)
═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Asymmetric Private Key
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
 /juice-shop/build/lib/insecurity.js:46 (offset: 2765 bytes) (added by 'COPY --chown=65532:0 /juice-shop . # bui')
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  44   const z85 = __importStar(require("z85"));
  45   exports.publicKey = node_fs_1.default ? node_fs_1.default.readFileSync('encryptionkeys/jwt.pub', 'ut
  46 [ ----BEGIN RSA PRIVATE KEY-----****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************-----END RSA PRIVATE
  47   const hash = (data) => node_crypto_1.default.createHash('md5').update(data).digest('hex');
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

/juice-shop/lib/insecurity.ts (secrets)
=======================================
Total: 1 (HIGH: 1, CRITICAL: 0)

HIGH: AsymmetricPrivateKey (private-key)
═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Asymmetric Private Key
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
 /juice-shop/lib/insecurity.ts:23 (offset: 791 bytes) (added by 'COPY --chown=65532:0 /juice-shop . # bui')
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  21   
  22   export const publicKey = fs ? fs.readFileSync('encryptionkeys/jwt.pub', 'utf8') : 'placeholder-publi
  23 [ ----BEGIN RSA PRIVATE KEY-----****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************-----END RSA PRIVATE
  24   
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
