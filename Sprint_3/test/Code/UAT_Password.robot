*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}		    Edge
${TEST_URL}                 https://csse1569.cpkku.com/

${ANAME}		    admin123
${APASS}		    123456789
${ONAME}		    domthap1
${OPASS}		    Domthap1
${EMAIL}		    somyod@kkumail.com
${RNAME}		    somsee1234
${RPASS}		    123456789
${REMAIL}		    test1@kkumail.com
${Succes_PASS}		    apple-mango_dog
${New_NAME}		    domthap2
${New_PASS}		    apple-mango-deer---
${current_pass}             apple-mango-deer--
${Past_pass}                apple-mango-deer-
*** Keywords ***
open Edge
    Open Browser    ${TEST_URL}    ${BROWSER}
    Set Selenium Speed    0.2 seconds
    Maximize Browser Window
register success
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    ${RNAME}
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      ${Succes_PASS}
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      ${Succes_PASS}
    Click Button    ถัดไป
password less than 8 
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    ${RNAME}
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      123fgh
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      123fgh
    Click Button    ถัดไป
    #Click Element    css=button[type="submit"]
    #Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
common password one 
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    ${RNAME}
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      123456789
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      123456789
    Click Button    ถัดไป
    sleep    0.2 seconds
    
common password two 
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    ${RNAME}
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      abcde12345
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      abcde12345
    Click Button    ถัดไป
comfirm password not same 
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    ${RNAME}
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      123fgh-gd
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      123fgh-gdf
    Click Button    ถัดไป
    #Click Element    css=button[type="submit"]
    #Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
password same with username
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    outlierscarvings
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      outlierscarvings
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      outlierscarvings
    Click Button    ถัดไป
    #Click Element    css=button[type="submit"]
    #Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
password same with email
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    outlierscarvings
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      ${REMAIL}
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      ${REMAIL}
    Click Button    ถัดไป
    Wait Until Page Contains    รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล    10s
password has space
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    ${RNAME}
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      apple-mango- deer
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      apple-mango- deer
    Click Button    ถัดไป
login fail 3 times
    Wait Until Element Is Visible    css=a[href="/login"]    15s
    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Wait Until Page Contains    ชื่อผู้ใช้ หรือ อีเมล    10s
    Input Text    id=identifier    yysomyod1231121
    Input Text    id=password      yySomyod1232
    Click Element    css=button[type="submit"]
    #Page Should Contain    เข้าสู่ระบบไม่สำเร็จ (สามารถกรอกได้อีก 2 ครั้ง)    10s
    Wait Until Page Contains    เข้าสู่ระบบไม่สำเร็จ    10s
    Input Text    id=identifier    yysomyod1231121
    Input Text    id=password      yyySomyod1232
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เข้าสู่ระบบไม่สำเร็จ    10s
    Input Text    id=identifier    yysomyod1231121
    Input Text    id=password      yyyySomyod1232
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    บัญชีถูกระงับ    10s
    #Click Button    ปิด
    #Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล    10s
no meaning password one
    Wait Until Element Is Visible    css=a[href="/register"]    15s
    Click Element    css=a[href="/register"]
    Page Should Contain     สมัครสมาชิก
    Input Text    id=username    ${RNAME}
    Input Text    id=email       ${REMAIL}
    Input Text    id=password      gon-mando-gistra
    Scroll Element Into View    id=confirmPassword
    Input Text    id=confirmPassword      gon-mando-gistra
    Click Button    ถัดไป

old user change password without old password
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=newPassword    somyod123
    Input Text    id=confirmNewPassword      Somyod123
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s


login as old user
    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${ONAME}
    Input Text    id=password      ${OPASS}
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    รหัสผ่านของคุณไม่ปลอดภัยเพียงพอ    10s
    Click Element    xpath=(//button[normalize-space()="ข้ามไปก่อน"])
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s
login as new user
    Click Element    css=a[href="/login"]
    sleep    0.3 seconds
    Page Should Contain    ชื่อผู้ใช้ หรือ อีเมล
    Input Text    id=identifier    ${New_NAME}
    Input Text    id=password      ${current_pass}
    Click Element    css=button[type="submit"]
    Wait Until Page Does Not Contain Element    css=a[href="/login"]    10s


change password with wrong old password
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   apple-new-deerJohnn
    Input Text    id=newPassword    apple-lime-deer
    Input Text    id=confirmNewPassword      apple-lime-deer
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s
change password less than 8 
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   ${current_pass}
    Input Text    id=newPassword    somyod12
    Input Text    id=confirmNewPassword      Somyod12
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s
change password with common password
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   ${current_pass}
    Input Text    id=newPassword    abcdefghigkl
    Input Text    id=confirmNewPassword      abcdefghigkl
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s
change password with 3 words password no meaning
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   appbumf-neyt-deeo
    Input Text    id=newPassword    apple-new-deer-
    Input Text    id=confirmNewPassword      apple-new-deer-
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s
change password not the same as confirm
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   ${current_pass}
    Input Text    id=newPassword    apple-new-deer
    Input Text    id=confirmNewPassword      apple-new-deer-
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s
change password same with username
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   ${current_pass}
    Input Text    id=newPassword    ${ONAME}
    Input Text    id=confirmNewPassword      ${ONAME}
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s
change password same with email
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   ${current_pass}
    Input Text    id=newPassword    test1@kkumail.com
    Input Text    id=confirmNewPassword      test1@kkumail.com
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    เกิดข้อผิดพลาด    10s
new password has space
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   ${current_pass}
    Input Text    id=newPassword    apple -mango- deer
    Input Text    id=confirmNewPassword      apple -mango- deer
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    รหัสผ่านใหม่ต้องไม่มีช่องว่าง    10s
user change new password success
    Mouse Over    xpath=//div[contains(@class,'hover:bg-blue-50')]
    Wait Until Element Is Visible    xpath=//button[contains(.,'Logout')]
    Click Element    css=a[href="/profile"]
    Location Should Contain    profile
    Scroll Element Into View    id=confirmNewPassword
    Input Text    id=currentPassword   ${current_pass}
    Input Text    id=newPassword    ${New_PASS}
    Input Text    id=confirmNewPassword      ${New_PASS}
    Click Element    css=button[type="submit"]
    Wait Until Page Contains    อัปเดตสำเร็จ!    15s
*** Test Cases ***
register successful
    Open Edge
    register success
    Wait Until Page Does Not Contain    รหัสผ่านแนะนำ    10s
    #Click Button    ย้อนกลับ
    Close Browser
unsuccess login fail 3 times:
    Open Edge
    login fail 3 times
    Close Browser

register unsuccess password less than 8:
    Open Edge
    password less than 8
    Page Should Contain    รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร    10s
    Close Browser
register unsuccess common password one:
    Open Edge
    common password one
    #Wait Until Page Contains    รหัสผ่านนี้อยู่ใน Blacklist ไม่สามารถใช้งานได้    10s
    Close Browser
register unsuccess common password two:
    Open Edge
    common password two
    #Wait Until Page Contains   รหัสผ่านนี้อยู่ใน Blacklist ไม่สามารถใช้งานได้    10s
    Close Browser
register unsuccess 3 words password no meaning:
    Open Edge
    no meaning password one
    Page Should Contain    รหัสผ่านต้องประกอบด้วยอย่างน้อย 3 คำ    10s
    Close Browser
register unsuccess password not the same as confirm:
    Open Edge
    comfirm password not same
    Page Should Contain    รหัสผ่านไม่ตรงกัน    10s
    Close Browser
register unsuccess password same with username:
    Open Edge
    password same with username
    Wait Until Page Contains    รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล    10s
    Close Browser
register unsuccess password same with email:
    Open Edge
    password same with email
    Close Browser
register unsuccess password has space:
    Open Edge
    password has space
    Wait Until Page Contains    รหัสผ่านต้องไม่มีช่องว่าง    10s
    Close Browser


unsuccess old user change password without old password:
    Open Edge
    login as old user
    old user change password without old password
    Close Browser
unsuccess user change password with wrong old password:
    Open Edge
    login as old user
    change password with wrong old password
    Close Browser
unsuccess user change password less than 8:
    Open Edge
    login as old user
    change password less than 8
    Wait Until Page Contains    รหัสผ่านใหม่และการยืนยันรหัสผ่านไม่ตรงกัน    10s
    Close Browser
unsuccess user change password with common password:
    Open Edge
    login as old user
    change password with common password
    #Wait Until Page Contains    รหัสผ่านนี้อยู่ใน Blacklist ไม่สามารถใช้งานได้    10s
    Close Browser
unsuccess user change password with 3 words password no meaning:
    Open Edge
    login as old user
    change password with 3 words password no meaning
    #Page Should Contain    รหัสผ่านต้องประกอบด้วยอย่างน้อย 3 คำ    10s
    Close Browser
unsuccess user change password not the same as confirm:
    Open Edge
    login as old user
    change password not the same as confirm
    Page Should Contain    รหัสผ่านไม่ตรงกัน    10s
    Close Browser
unsuccess user change password same with username:
    Open Edge
    login as old user
    change password same with username
    Wait Until Page Contains    รหัสผ่านต้องไม่มีชื่อผู้ใช้ อีเมล ชื่อจริง หรือนามสกุล    10s
    Close Browser
unsuccess user change password same with email:
    Open Edge
    login as old user
    change password same with email
    Close Browser
unsuccess new password has space:
    Open Edge
    login as old user
    new password has space
    Close Browser
user change password successful:
    Open Edge
    login as new user
    user change new password success
    Close Browser