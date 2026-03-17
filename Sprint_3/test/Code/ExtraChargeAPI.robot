*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           BuiltIn
Library           DateTime

Suite Setup    Run Keywords
...    Create Session    api    ${BASE_URL}    verify=False
...    AND
...    Get My Vehicle

Suite Teardown    Cleanup Created Route


*** Variables ***
${BASE_URL}           https://painamnae.onrender.com
${LOCAL_URL} 		  http://localhost:3000

${LOGIN_ENDPOINT}     /api/auth/login
${ROUTES_ENDPOINT}    /api/routes
${BOOKING_ENDPOINT}   /api/bookings

${DRIVER_USER}        drivertest02
${DRIVER_PASS}        dog-dog-cat
${PASSENGER_USER}     passengertest01
${PASSENGER_PASS}     dog-dog-cat

${ROUTE_ID}           None
${EXTRA_ID}           None
${BOOKING_ID}         None

${extraName1}		  Luggage

*** Test Cases ***

# A1 Driver Create Route With ExtraCharge
Driver Create Route With ExtraCharge
    ${token}=    Login    ${DRIVER_USER}    ${DRIVER_PASS}
    ${headers}=  Create Dictionary    Authorization=Bearer ${token}

    ${seats}=    Evaluate    3
    ${price}=    Evaluate    100
    ${EMPTY}=    Create List

    ${extra}=    Create Dictionary
    ...    name=${extraName1}
    ...    unitPrice=${price}

    ${extra_list}=    Create List    ${extra}
	${lat1}=    Evaluate    14.95070007510298
	${lng1}=    Evaluate    101.73226875
	${lat2}=    Evaluate    14.61077162017679
	${lng2}=    Evaluate    104.105315625

	${start}=    Create Dictionary    lat=${lat1}    lng=${lng1}
	${end}=      Create Dictionary    lat=${lat2}    lng=${lng2}

    ${body}=    Create Dictionary
    ...    startLocation=${start}
    ...    endLocation=${end}
    ...    departureTime=2026-12-10T10:00:00.000Z
    ...    availableSeats=${seats}
    ...    pricePerSeat=${price}
    ...    vehicleId=${VEHICLE_ID}
    ...    conditions=No smoking
    ...    optimizeWaypoints=${False}
    ...    waypoints=${EMPTY}
    ...    extraCharges=${extra_list}

    ${response}=    POST On Session
    ...    api
    ...    ${ROUTES_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Log    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    201
	
	${json}=        Set Variable    ${response.json()}
	${data}=        Get From Dictionary    ${json}    data
	${routeId}=     Get From Dictionary    ${data}    id
	Log             Created Route ID: ${routeId}
	Set Suite Variable    ${ROUTE_ID}    ${routeId}
	

# A2 Passenger View Route (ต้องเห็น extraCharge)
Passenger View Route Should Contain ExtraCharge
    ${response}=    GET On Session
    ...    api
    ...    ${ROUTES_ENDPOINT}/${ROUTE_ID}

    Should Be Equal As Integers    ${response.status_code}    200

    ${data}=          Get From Dictionary    ${response.json()}    data
    ${extra_list}=    Get From Dictionary    ${data}    routeExtraCharge

    Length Should Be    ${extra_list}    1
	Log					extra list: ${extra_list}

    ${first_extra}=    Get From List    ${extra_list}    0
    ${extraId}=    	   Get From Dictionary    ${first_extra}    id

    Set Suite Variable    ${EXTRA_ID}    ${extraId}

# A3-1 Passenger Booking With ExtraCharge
Passenger Booking With ExtraCharge Should Calculate TotalPrice
    ${token}=    Login    ${PASSENGER_USER}    ${PASSENGER_PASS}
    ${headers}=  Create Dictionary    Authorization=Bearer ${token}

    ${seat}=    Evaluate    1
    ${qty}=     Evaluate    2

    ${lat1}=    Evaluate    13.7563
    ${lng1}=    Evaluate    100.5018
    ${lat2}=    Evaluate    13.7367
    ${lng2}=    Evaluate    100.5231

    ${pickup}=     Create Dictionary    lat=${lat1}    lng=${lng1}
    ${dropoff}=    Create Dictionary    lat=${lat2}    lng=${lng2}

    ${selected}=    Create List    ${EXTRA_ID}

    ${quantities}=    Create Dictionary
    ...    ${EXTRA_ID}=${qty}

    ${body}=    Create Dictionary
    ...    routeId=${ROUTE_ID}
    ...    numberOfSeats=${seat}
    ...    pickupLocation=${pickup}
    ...    dropoffLocation=${dropoff}
    ...    selectedCharges=${selected}
    ...    chargeQuantities=${quantities}

    ${response}=    POST On Session
    ...    api
    ...    ${BOOKING_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Log    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    201

    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data

    ${base}=    Get From Dictionary    ${data}    baseTotalPrice
    ${extra}=   Get From Dictionary    ${data}    extraTotalPrice
    ${total}=   Get From Dictionary    ${data}    totalPrice

    Should Be Equal As Numbers    ${base}    100
    Should Be Equal As Numbers    ${extra}   200
    Should Be Equal As Numbers    ${total}   300

# A3-2 Passenger Booking Without ExtraCharge
Passenger Booking Without ExtraCharge Should Not Add Extra
    ${token}=    Login    ${PASSENGER_USER}    ${PASSENGER_PASS}
    ${headers}=  Create Dictionary    Authorization=Bearer ${token}

    ${seat}=    Evaluate    1

    ${lat1}=    Evaluate    13.7563
    ${lng1}=    Evaluate    100.5018
    ${lat2}=    Evaluate    13.7367
    ${lng2}=    Evaluate    100.5231

    ${pickup}=     Create Dictionary    lat=${lat1}    lng=${lng1}
    ${dropoff}=    Create Dictionary    lat=${lat2}    lng=${lng2}

    ${body}=    Create Dictionary
    ...    routeId=${ROUTE_ID}
    ...    numberOfSeats=${seat}
    ...    pickupLocation=${pickup}
    ...    dropoffLocation=${dropoff}

    ${response}=    POST On Session
    ...    api
    ...    ${BOOKING_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    201

    ${data}=    Get From Dictionary    ${response.json()}    data
    ${extra}=   Get From Dictionary    ${data}    extraTotalPrice
    ${total}=   Get From Dictionary    ${data}    totalPrice

    Should Be Equal As Numbers    ${extra}   0
    Should Be Equal As Numbers    ${total}   100

# Validation Test
Booking With Invalid ExtraCharge Should Return 400
    ${token}=    Login    ${PASSENGER_USER}    ${PASSENGER_PASS}
    ${headers}=  Create Dictionary    Authorization=Bearer ${token}

    ${seat}=    Evaluate    1
    ${qty}=     Evaluate    1

    ${lat1}=    Evaluate    13.7563
    ${lng1}=    Evaluate    100.5018
    ${lat2}=    Evaluate    13.7367
    ${lng2}=    Evaluate    100.5231

    ${pickup}=     Create Dictionary    lat=${lat1}    lng=${lng1}
    ${dropoff}=    Create Dictionary    lat=${lat2}    lng=${lng2}

    ${selected}=    Create List    invalid_id

    ${quantities}=    Create Dictionary
    ...    invalid_id=${qty}

    ${body}=    Create Dictionary
    ...    routeId=${ROUTE_ID}
    ...    numberOfSeats=${seat}
    ...    pickupLocation=${pickup}
    ...    dropoffLocation=${dropoff}
    ...    selectedCharges=${selected}
    ...    chargeQuantities=${quantities}

    ${response}=    POST On Session
    ...    api
    ...    ${BOOKING_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    Should Be Equal As Integers    ${response.status_code}    400

# Performance Test
Create Booking Response Time Should Be < 2 Seconds
    ${token}=    Login    ${PASSENGER_USER}    ${PASSENGER_PASS}
    ${headers}=  Create Dictionary    Authorization=Bearer ${token}

    ${seat}=    Evaluate    1

    ${lat1}=    Evaluate    13.7563
    ${lng1}=    Evaluate    100.5018
    ${lat2}=    Evaluate    13.7367
    ${lng2}=    Evaluate    100.5231

    ${pickup}=     Create Dictionary    lat=${lat1}    lng=${lng1}
    ${dropoff}=    Create Dictionary    lat=${lat2}    lng=${lng2}

    ${body}=    Create Dictionary
    ...    routeId=${ROUTE_ID}
    ...    numberOfSeats=${seat}
    ...    pickupLocation=${pickup}
    ...    dropoffLocation=${dropoff}

    ${start}=    Get Time    epoch

    ${response}=    POST On Session
    ...    api
    ...    ${BOOKING_ENDPOINT}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any

    ${end}=    Get Time    epoch
    ${duration}=    Evaluate    ${end} - ${start}

    Should Be True    ${duration} < 2


*** Keywords ***
Login
    [Arguments]    ${username}    ${password}

    ${body}=    Create Dictionary
    ...    username=${username}
    ...    password=${password}

    ${response}=    POST On Session
    ...    api
    ...    ${LOGIN_ENDPOINT}
    ...    json=${body}

    Should Be Equal As Integers    ${response.status_code}    200

    ${data}=    Get From Dictionary    ${response.json()}    data
    ${token}=   Get From Dictionary    ${data}    token

    RETURN    ${token}
	
Get My Vehicle
    ${token}=    Login    ${DRIVER_USER}    ${DRIVER_PASS}
    ${headers}=  Create Dictionary    Authorization=Bearer ${token}

    ${response}=    GET On Session
    ...    api
    ...    /api/vehicles
    ...    headers=${headers}

    Should Be Equal As Integers    ${response.status_code}    200

    ${json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${json}    data

    Run Keyword If    ${data} == []    Fail    Driver has no vehicle in production

    ${first}=   Get From List    ${data}    0
    ${vehicleId}=    Get From Dictionary    ${first}    id

    Set Suite Variable    ${VEHICLE_ID}    ${vehicleId}
	
Cleanup Created Route
    Run Keyword If    '${ROUTE_ID}' != 'None'    Delete Route


Delete Route
    ${token}=    Login    ${DRIVER_USER}    ${DRIVER_PASS}
    ${headers}=  Create Dictionary    Authorization=Bearer ${token}

    ${endpoint}=    Set Variable    ${ROUTES_ENDPOINT}/${ROUTE_ID}

    ${response}=    DELETE On Session
    ...    api
    ...    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any

    Log    Deleted Route Response: ${response.status_code}