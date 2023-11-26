global class DesativarContasSchedule implements Schedulable {
    
    // Script para agendamento desta classe (Segunda a Sexta - 4x ao dia):
    // System.schedule('Desativar Contas', '0 0 0/6 ? * MON,TUE,WED,THU,FRI *', new DesativarContasSchedule());

    global void execute(SchedulableContext ctx){
        String query = 'SELECT Id, (SELECT id FROM Tasks WHERE CreatedDate >= LAST_N_DAYS:90), (SELECT id FROM Opportunities WHERE (CloseDate >= LAST_N_DAYS:120 AND StageName = \'Closed Won\') OR (StageName = \'Negotiation/Review\')) FROM Account';
        DesativarContasBatch batch = new DesativarContasBatch(query);
        Database.executebatch(batch, 200);
    }
}