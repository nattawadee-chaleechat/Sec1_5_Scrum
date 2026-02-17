*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}		    Edge
${TEST_URL}                 https://csse1569.cpkku.com/

${ANAME}		    admin123
${APASS}		    123456789
${DNAME}		    admin123
${DPASS}		    123456789
${PNAME}		    somyod123
${PPASS}		    Somyod123
${LAST_NAME}		    Sodsai
${ORGANIZATION}		    CS KKU
${EMAIL}		    somyod@kkumail.com
${PHONE}		    0910011234

*** Test Cases ***
Review Success without comment:
    Open Browser    ${TEST_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    css=a[href="/login"]    15s
    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${DNAME}
    Input Text    id=password      ${DPASS}
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s

    Mouse Over    css=a[href="/myTrip"] 
    Wait Until Element Is Visible    css=a[href="/myRoute"]
    Click Element    css=a[href="/myRoute"]
    Wait Until Location Contains    myRoute    10s
    Location Should Contain    myRoute

    Click Element    xpath=//button[contains(.,'ยืนยันแล้ว')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]
    #Scroll Element Into View    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]
    #Wait Until Element Is Visible    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]    10s
    Sleep    5 seconds
    Click Element    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'ใช่! สิ้นสุดการเดินทาง')]
    Click Element    xpath=//button[contains(.,'ใช่! สิ้นสุดการเดินทาง')]
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Button  Logout
    Capture Page Screenshot

    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${PNAME}
    Input Text    id=password      ${PPASS}
    #Click Button    เข้าสู่ระบบ
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
    Click Element    css=a[href="/myTrip"]
    Wait Until Location Contains    myTrip    10s
    Location Should Contain    myTrip
    #Sleep    5 seconds
    Click Element    xpath=//button[contains(.,'ยืนยันแล้ว')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]
    Click Element    xpath=//button[contains(.,'สิ้นสุดการเดินทาง')]
    Click Element    xpath=//button[contains(.,'ใช่! สิ้นสุดการเดินทาง')]
    Capture Page Screenshot
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Button  Logout

    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${PNAME}
    Input Text    id=password      ${PPASS}
    #Click Button    เข้าสู่ระบบ
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
    Click Element    css=a[href="/myTrip"]
    Wait Until Location Contains    myTrip    10s
    Location Should Contain    myTrip
    
    Click Element    xpath=//button[contains(.,'การเดินทางเสร็จสิ้น')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'รีวิวการเดินทาง')]
    Click Element    xpath=//button[contains(.,'รีวิวการเดินทาง')]
    Execute JavaScript    document.evaluate("(//span[contains(@class,'cursor-pointer')])[3]",    document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)    .singleNodeValue.click();
    Choose File    xpath=//input[@type='file']    C:/Users/Dom/Downloads/professerEX.jpg
    #sleep    10 seconds
    #Scroll Element Into View    xpath=//button[contains(.,'ส่งรีวืว')]
    #Wait Until Element Is Visible    xpath=//button[contains(.,'ส่งรีวิว')]    10s
    Execute JavaScript    document.evaluate("//button[normalize-space()='ส่งรีวิว']",    document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)    .singleNodeValue.click();
    Capture Page Screenshot
    Close Browser