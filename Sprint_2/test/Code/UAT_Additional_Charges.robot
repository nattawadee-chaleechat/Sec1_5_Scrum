*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}		    Edge
${TEST_URL}                 https://csse1569.cpkku.com/

${ANAME}		    admin123
${APASS}		    123456789
${PNAME}		    somyod123
${PPASS}		    Somyod123
${DNAME}		    admin123
${DPASS}		    123456789
${LAST_NAME}		    Sodsai
${ORGANIZATION}		    CS KKU
${EMAIL}		    somyod@kkumail.com
${PHONE}		    0910011234
${date}=    Get Current Date    result_format=%Y-%m-%d
${time}=    Get Current Date    result_format=%H:%M    increment=1 hour
*** Keywords ***
open Edge
    Open Browser    ${TEST_URL}    ${BROWSER}
    Maximize Browser Window
login as driver
    Wait Until Element Is Visible    css=a[href="/login"]    15s
    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${DNAME}
    Input Text    id=password      ${DPASS}
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
login as passenger
    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${PNAME}
    Input Text    id=password      ${PPASS}
    #Click Button    เข้าสู่ระบบ
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
login as admin
    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${ANAME}
    Input Text    id=password      ${APASS}
    #Click Button    เข้าสู่ระบบ
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
create route
    Click Element    css=a[href="/createTrip"]
    Wait Until Element Is Visible    id=travelDate    10s
    Clear Element Text    id=startPoint
    Input Text    id=startPoint    Kanchanaburi
    Press Keys    id=startPoint    SPACE
    Press Keys    id=startPoint    BACKSPACE
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"pac-item")])[1]    12s
    Click Element    xpath=(//div[contains(@class,"pac-item")])[1]
    Clear Element Text    id=endPoint
    Input Text    id=endPoint    Kanchanaburi
    Press Keys    id=endPoint    SPACE
    Press Keys    id=endPoint    BACKSPACE
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"pac-item")])[1]    12s
    Click Element    xpath=(//div[contains(@class,"pac-item")])[1]
    Execute Javascript
    ...    var el = document.getElementById("travelDate");
    ...    el.value = "2026-04-04";
    ...    el.dispatchEvent(new Event('input'));
    ...    el.dispatchEvent(new Event('change'));
    #Input Text    id=travelDate    2026-04-04
    Scroll Element Into View    id=travelTime
    Input Text    id=travelTime    18:17
    Scroll Element Into View    id=seatCount
    #Capture Page Screenshot
    Input Text    id=seatCount   1
    Scroll Element Into View    id=pricePerSeat
    Input Text    id=pricePerSeat   200
condition all
    Scroll Element Into View    id=terms
    Input Text    id=terms   ไม่สูบบุหรี่
    Wait Until Element Is Visible    xpath=//button[normalize-space()='เพิ่มเงื่อนไข']
    Scroll Element Into View         xpath=//button[normalize-space()='เพิ่มเงื่อนไข']
    Click Element                    xpath=//button[normalize-space()='เพิ่มเงื่อนไข']
    Wait Until Element Is Visible    xpath=//input[contains(@placeholder,'เงื่อนไข')]
    Input Text    (//input[contains(@placeholder,'เงื่อนไข')])[last()]    เพิ่มกระเป๋า
    Input Text    (//input[@type='number'])[last()]    10
    Scroll Element Into View    css=button[type="submit"]
    sleep    1 seconds
    Click Element    css=button[type="submit"]
    Wait Until Element Is Visible    xpath=//*[contains(text(),"สำเร็จ")]    10s
    Element Should Contain           xpath=//*[contains(text(),"สำเร็จ")]    สำเร็จ
    Wait Until Location Contains    findTrip    10s
log out
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Button  Logout
gettrip
    Click Element    css=a[href="/findTrip"]
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"route-card")])[1]    10s
    Click Element    xpath=(//div[contains(@class,"route-card")])[1]
    Execute Javascript    window.scrollTo(0, document.body.scrollHeight)
passenger check trip
    Scroll Element Into View    xpath=//button[contains(text(),"จองที่นั่ง")]
    Click Button    xpath=//button[contains(text(),"จองที่นั่ง")]
    Wait Until Page Contains    เดินทางกับ    10s
    sleep    1 seconds
    ${modal}=    Get WebElement    xpath=//div[contains(@class,"modal-content")]
    Execute Javascript
    ...    var modal = document.querySelector('.modal-content');
    ...    modal.scrollTop = modal.scrollHeight;

    Wait Until Element Is Visible    xpath=//input[@placeholder="พิมพ์ชื่อสถานที่..."]    10s
    ${passengerStartPoint}=    Get WebElement
    ...    xpath=//label[contains(text(),"เลือกจุดขึ้นรถ")]/following::input[1] 
    Clear Element Text    ${passengerStartPoint}
    Input Text       ${passengerStartPoint}    Kanchanaburi    
    Press Keys    (//input[@placeholder="พิมพ์ชื่อสถานที่..."])[1]    SPACE
    Press Keys    (//input[@placeholder="พิมพ์ชื่อสถานที่..."])[1]    BACKSPACE
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"pac-item")])[1]    10s
    Click Element    xpath=(//div[contains(@class,"pac-item")])[1]

    Wait Until Element Is Visible    xpath=//input[@placeholder="พิมพ์ชื่อสถานที่..."]    10s
    ${passengerEndPoint}=    Get WebElement
    ...    xpath=//label[contains(text(),"เลือกจุดขึ้นรถ")]/following::input[2] 
    Clear Element Text    ${passengerEndPoint}
    Input Text       ${passengerEndPoint}    Kanchanaburi    
    Press Keys    (//input[@placeholder="พิมพ์ชื่อสถานที่..."])[2]    SPACE  
    Press Keys    (//input[@placeholder="พิมพ์ชื่อสถานที่..."])[2]    BACKSPACE
    Wait Until Element Is Visible    xpath=(//div[contains(@class,"pac-item")])[2]    10s
    Click Element    xpath=(//div[contains(@class,"pac-item")])[2]
go to driver route 
    Mouse Over    css=a[href="/myTrip"] 
    Wait Until Element Is Visible    css=a[href="/myRoute"]
    Click Element    css=a[href="/myRoute"]
    Wait Until Location Contains    myRoute    10s
    Location Should Contain    myRoute
driver confirm trip
    Wait Until Element Is Visible    xpath=(//button[normalize-space()="ยืนยันคำขอ"])[1]    10s
    Click Element    xpath=(//button[normalize-space()="ยืนยันคำขอ"])[1]
    Wait Until Element Is Visible    xpath=//div[contains(@class,"modal-content")]    10s
    Click Element    xpath=//div[contains(@class,"modal-content")]//button[normalize-space()="ยืนยันคำขอ"]
    Wait Until Element Is Visible    xpath=//*[contains(text(),"สำเร็จ")]    10s
    Element Should Contain           xpath=//*[contains(text(),"สำเร็จ")]    สำเร็จ
no extra charge
    Scroll Element Into View    id=terms
    Input Text    id=terms   ไม่สูบบุหรี่
    Scroll Element Into View    css=button[type="submit"]
    sleep    1 seconds
    Click Element    css=button[type="submit"]
    Wait Until Element Is Visible    xpath=//*[contains(text(),"สำเร็จ")]    10s
    Element Should Contain           xpath=//*[contains(text(),"สำเร็จ")]    สำเร็จ
    Wait Until Location Contains    findTrip    10s

*** Test Cases ***
Passenger accept condition and extra charge:
    open Edge
    login as admin
    create route
    condition all
    log out
    login as passenger
    gettrip
     #เช็คเงื่อนไข
    Wait Until Page Contains    ไม่สูบบุหรี่    10s
    Scroll Element Into View    xpath=//*[contains(text(),"สูบบุหรี่")]
    Scroll Element Into View    xpath=//button[contains(text(),"จองที่นั่ง")]
    Element Should Be Visible    xpath=//*[contains(text(),"ไม่สูบบุหรี่")]
    Page Should Contain    ไม่สูบบุหรี่

    passenger check trip
    Scroll Element Into View   xpath=//input[@type="checkbox"]
    Click Element    xpath=//input[@type="checkbox"]
    #Select From List By Label    xpath=//select    1 ที่นั่ง
    Scroll Element Into View    xpath=//button[contains(text(),"ยืนยันการจอง")]
    Click Button    xpath=//button[contains(text(),"ยืนยันการจอง")]
    sleep    2.5 seconds
    Page Should Contain    ส่งคำขอจองสำเร็จ!    12s
    log out
    login as admin
    go to driver route
    driver confirm trip
    log out
    Close Browser

Passenger accept condition without extra charge:
    open Edge
    login as admin
    create route
    condition all
    log out
    login as passenger
    gettrip
     #เช็คเงื่อนไข
    Wait Until Page Contains    ไม่สูบบุหรี่    10s
    Scroll Element Into View    xpath=//*[contains(text(),"สูบบุหรี่")]
    Scroll Element Into View    xpath=//button[contains(text(),"จองที่นั่ง")]
    Element Should Be Visible    xpath=//*[contains(text(),"ไม่สูบบุหรี่")]
    Page Should Contain    ไม่สูบบุหรี่

    passenger check trip
    Scroll Element Into View   xpath=//input[@type="checkbox"]

    Scroll Element Into View    xpath=//button[contains(text(),"ยืนยันการจอง")]
    Click Button    xpath=//button[contains(text(),"ยืนยันการจอง")]
    sleep    2.5 seconds
    Page Should Contain    ส่งคำขอจองสำเร็จ!    12s
    log out
    login as admin
    go to driver route
    driver confirm trip
    log out
    Close Browser

Driver no extra charge:
    open Edge
    login as admin
    create route
    no extra charge
    log out
    login as passenger
    gettrip
     #เช็คเงื่อนไข
    Wait Until Page Contains    ไม่สูบบุหรี่    10s
    Scroll Element Into View    xpath=//*[contains(text(),"ไม่สูบบุหรี่")]
    Scroll Element Into View    xpath=//button[contains(text(),"จองที่นั่ง")]
    Element Should Be Visible    xpath=//*[contains(text(),"ไม่สูบบุหรี่")]

    passenger check trip
    #Select From List By Label    xpath=//select    1 ที่นั่ง
    Scroll Element Into View    xpath=//button[contains(text(),"ยืนยันการจอง")]
    Click Button    xpath=//button[contains(text(),"ยืนยันการจอง")]
    sleep    2.5 seconds
    Page Should Contain    ส่งคำขอจองสำเร็จ!    12s
    log out
    login as admin
    go to driver route
    driver confirm trip
    log out
    Close Browser

    
