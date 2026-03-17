*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary

Suite Setup    My Suite Setup
Test Setup     Clean Before Test
Test Teardown  Clean After Test

*** Variables ***
${BROWSER}         Edge
${TEST_URL}        https://csse1569.cpkku.com/
${API_URL}         https://painamnae.onrender.com/

${PNAME}           somsee123
${PPASS}           Somsee123
${DNAME}           admin123
${DPASS}           123456789

*** Keywords ***

My Suite Setup
    Create Session    api    ${API_URL}
    Set Selenium Speed    0.2s

# ===== API =====
Reset All Data
    Run Keyword And Ignore Error    POST On Session    api    /test/reset-route

Seed Route
    Run Keyword And Ignore Error    POST On Session    api    /test/seed-route

Clean Before Test
    Reset All Data
    Seed Route

Clean After Test
    Reset All Data
    Seed Route

# ===== UTIL =====
Select Location Input
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    10s
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}
    Press Keys    ${locator}    SPACE
    Press Keys    ${locator}    BACKSPACE
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"pac-item")])[1]    10s
    Click Element    xpath=(//div[contains(@class,"pac-item")])[1]

open Edge
    Open Browser    ${TEST_URL}    ${BROWSER}
    Maximize Browser Window

Login
    [Arguments]    ${USER}    ${PASS}
    Click Element    css=a[href="/login"]
    Input Text    id=identifier    ${USER}
    Input Text    id=password      ${PASS}
    Click Element    css=button[type="submit"]

    ${popup}=    Run Keyword And Return Status
    ...    Wait Until Page Contains    รหัสผ่านของคุณไม่ปลอดภัยเพียงพอ    3s
    IF    ${popup}
        Click Element    xpath=//button[contains(.,'ข้ามไปก่อน')]
    END

    Wait Until Location Does Not Contain    /login    10s

Logout
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]    10s
    Click Button    Logout

# ================= DRIVER =================

Create Route
    Click Element    css=a[href="/createTrip"]
    Wait Until Element Is Visible    id=travelDate    10s

    Select Location Input    id=startPoint    Kanchanaburi
    Select Location Input    id=endPoint      Kanchanaburi

    Execute Javascript
    ...    var el = document.getElementById("travelDate");
    ...    el.value = "2026-04-04";
    ...    el.dispatchEvent(new Event('input'));
    ...    el.dispatchEvent(new Event('change'));

    Input Text    id=travelTime    18:00
    Input Text    id=seatCount     1
    Input Text    id=pricePerSeat  200

Condition All
    Scroll Element Into View    id=terms
    Input Text    id=terms   ไม่สูบบุหรี่

    Click Element    xpath=//button[normalize-space()='เพิ่มเงื่อนไข']
    Wait Until Element Is Visible    xpath=//input[contains(@placeholder,'เงื่อนไข')]    10s

    Input Text    (//input[contains(@placeholder,'เงื่อนไข')])[last()]    เพิ่มกระเป๋า
    Input Text    (//input[@type='number'])[last()]    10

    Click Element    css=button[type="submit"]
    Wait Until Page Contains    สำเร็จ    10s

Condition Create And Remove
    Scroll Element Into View    id=terms
    Input Text    id=terms   ไม่สูบบุหรี่

    Click Element    xpath=//button[normalize-space()='เพิ่มเงื่อนไข']
    Wait Until Element Is Visible    xpath=//input[contains(@placeholder,'เงื่อนไข')]    10s

    Input Text    (//input[contains(@placeholder,'เงื่อนไข')])[last()]    เพิ่มกระเป๋า
    Input Text    (//input[@type='number'])[last()]    10

    Click Element    xpath=//button[contains(text(),"ลบ")]
    Click Element    css=button[type="submit"]

    Wait Until Page Contains    สำเร็จ    10s

No Extra Charge
    Input Text    id=terms   ไม่สูบบุหรี่
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    สำเร็จ    10s

Go To Driver Route
    Mouse Over    css=a[href="/myTrip"]
    Wait Until Element Is Visible    css=a[href="/myRoute"]
    Click Element    css=a[href="/myRoute"]
    Wait Until Location Contains    myRoute    10s

Driver Confirm Trip
    Wait Until Element Is Visible    xpath=(//button[normalize-space()="ยืนยันคำขอ"])[1]    10s
    Click Element    xpath=(//button[normalize-space()="ยืนยันคำขอ"])[1]

    Wait Until Element Is Visible    xpath=//div[contains(@class,"modal-content")]    10s
    Click Element    xpath=//div[contains(@class,"modal-content")]//button[normalize-space()="ยืนยันคำขอ"]

    Wait Until Page Contains    สำเร็จ    10s

# ================= PASSENGER =================

Get Trip
    Click Element    css=a[href="/findTrip"]
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"route-card")])[1]    10s
    Click Element    xpath=(//div[contains(@class,"route-card")])[1]

Passenger Check Trip
    Scroll Element Into View    xpath=//button[contains(text(),"จองที่นั่ง")]
    Click Element    xpath=//button[contains(text(),"จองที่นั่ง")]

    Wait Until Page Contains    เดินทางกับ    10s

    Wait Until Element Is Visible    xpath=//div[contains(@class,"modal-content")]    10s

    Execute Javascript
    ...    document.querySelector('.modal-content').scrollTop =
    ...    document.querySelector('.modal-content').scrollHeight;

    # START
    Input Text    xpath=(//input[@placeholder="พิมพ์ชื่อสถานที่..."])[1]    Kanchanaburi
    Press Keys    xpath=(//input[@placeholder="พิมพ์ชื่อสถานที่..."])[1]    SPACE
    Press Keys    xpath=(//input[@placeholder="พิมพ์ชื่อสถานที่..."])[1]    BACKSPACE
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"pac-item")])[1]    10s
    Click Element    xpath=(//div[contains(@class,"pac-item")])[1]

    # END
    Input Text    xpath=(//input[@placeholder="พิมพ์ชื่อสถานที่..."])[2]    Kanchanaburi
    Press Keys    xpath=(//input[@placeholder="พิมพ์ชื่อสถานที่..."])[2]    SPACE
    Press Keys    xpath=(//input[@placeholder="พิมพ์ชื่อสถานที่..."])[2]    BACKSPACE
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"pac-item")])[1]    10s
    Click Element    xpath=(//div[contains(@class,"pac-item")])[1]

Confirm Booking
    Click Element    xpath=//button[contains(text(),"ยืนยันการจอง")]
    Wait Until Page Contains    ส่งคำขอจองสำเร็จ    10s

Accept Condition And Book
    Wait Until Element Is Visible    xpath=//input[@type="checkbox"]    10s
    Click Element    xpath=//input[@type="checkbox"]
    Click Element    xpath=//button[contains(text(),"ยืนยันการจอง")]
    Wait Until Page Contains    ส่งคำขอจองสำเร็จ    10s

# ================= TEST =================

*** Test Cases ***

Passenger accept condition
    open Edge
    Login    ${DNAME}    ${DPASS}
    Create Route
    Condition All
    Logout

    Login    ${PNAME}    ${PPASS}
    Get Trip
    Passenger Check Trip
    Accept Condition And Book
    Logout

    Login    ${DNAME}    ${DPASS}
    Go To Driver Route
    Driver Confirm Trip
    Close Browser


Passenger create condition then remove
    open Edge
    Login    ${DNAME}    ${DPASS}
    Create Route
    Condition Create And Remove
    Logout

    Login    ${PNAME}    ${PPASS}
    Get Trip
    Passenger Check Trip
    Page Should Not Contain Element    xpath=//input[@type="checkbox"]
    Confirm Booking
    Logout

    Login    ${DNAME}    ${DPASS}
    Go To Driver Route
    Driver Confirm Trip
    Close Browser


Passenger not accept condition
    open Edge
    Login    ${DNAME}    ${DPASS}
    Create Route
    Condition All
    Logout

    Login    ${PNAME}    ${PPASS}
    Get Trip
    Passenger Check Trip
    Confirm Booking
    Logout
    Close Browser


Driver no extra charge
    open Edge
    Login    ${DNAME}    ${DPASS}
    Create Route
    No Extra Charge
    Logout

    Login    ${PNAME}    ${PPASS}
    Get Trip
    Passenger Check Trip
    Confirm Booking
    Logout

    Login    ${DNAME}    ${DPASS}
    Go To Driver Route
    Driver Confirm Trip
    Close Browser