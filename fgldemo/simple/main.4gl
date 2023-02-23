IMPORT util
IMPORT os
IMPORT FGL fgldialog
CONSTANT LOCALNT = "LocalNotification"
CONSTANT CALLWOW = "callWithoutWaiting"
TYPE TTriggerOptions RECORD
  type STRING, --can be one of: location,calendar
  every STRING, --can be one of: minute,our,day,week,month,year
  at STRING,
  unit STRING,
  center ARRAY[2] OF FLOAT,
  radius FLOAT,
  single BOOLEAN,
  notifyOnEntry BOOLEAN,
  notifyOnExit BOOLEAN,
  in FLOAT
END RECORD

TYPE TActions RECORD
  id STRING,
  title STRING,
  type STRING,
  emptyText STRING
END RECORD

DEFINE options RECORD
  title STRING,
  subtitle STRING,
  text STRING,
  sound INT,
  badge INT,
  id INT,
  trigger TTriggerOptions,
  actions DYNAMIC ARRAY OF TActions
--actionGroupId STRING
--attachments STRING
END RECORD
DEFINE _ncount INT
MAIN
  DEFINE retstr STRING
  CALL fgl_refresh()
  --declare we are ready
  CALL ui.Interface.frontCall("cordova", CALLWOW, [LOCALNT, "ready"], [])
  --request permission
  CALL ui.Interface.frontCall("cordova", CALLWOW, [LOCALNT, "request"], [])
  MENU "Test"
    COMMAND "Schedule"
      CALL schedule()
    ON ACTION cordovacallback ATTRIBUTE(DEFAULTVIEW=NO)
      CALL handleCallbacks()
    COMMAND "Exit"
      EXIT MENU
  END MENU
END MAIN

FUNCTION schedule()
  DEFINE result STRING
  INITIALIZE options TO NULL
  LET options.title = "The title"
  LET options.text = "The notification text"
  LET options.sound = 1
  LET options.badge = 2
  LET options.trigger.type = "calendar"
  LET options.trigger.in = 5
  LET options.trigger.unit = "second"
  LET _ncount = _ncount + 1
  LET options.id = _ncount

  TRY
    CALL ui.Interface.frontCall(
        "cordova", CALLWOW, [LOCALNT, "schedule", options], [result])
    MESSAGE result
  CATCH
    ERROR err_get(status)
  END TRY
END FUNCTION

FUNCTION handleCallbacks()
  DEFINE all STRING
  CALL ui.Interface.frontCall("cordova", "getAllCallbackData", [], [all])
  ERROR SFMT("handleCallbacks %1", util.JSON.stringify(all))
END FUNCTION
