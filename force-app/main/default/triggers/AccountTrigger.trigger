trigger AccountTrigger on Account (before insert, before update, after insert) {
    TriggerHandler handler = new AccountTriggerHandler();
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            handler.beforeInsert(Trigger.New);
        }
        else if(Trigger.isUpdate){
            handler.beforeUpdate(Trigger.Old, Trigger.New, Trigger.OldMap, Trigger.NewMap);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            handler.afterInsert(Trigger.New);
        }
    }
}