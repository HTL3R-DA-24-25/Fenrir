import cron from 'node-cron';

export type DatapointTimer = {
    mes_id: number;
    xid: string;
    date: Date;
    startTime: string;
    endTime: string;
    active: boolean;
}

const datapointTimers: DatapointTimer[] = [];
const cronJobs = new Map<string, cron.ScheduledTask>();
let currentMaxId = 0;

export function addDatapointTimer (datapointTimer: DatapointTimer, host: string) {
    datapointTimer.mes_id = currentMaxId++;
    scheduleCronJob(datapointTimer, host);
    datapointTimers.push(datapointTimer);
}

export function getDatapointTimers () {
    return datapointTimers;
}

export function deleteDatapointTimer( mes_id: number ) {
    const index = datapointTimers.findIndex( (datapointTimer) => datapointTimer.mes_id === mes_id );
    if (index > -1) {
        datapointTimers.splice(index, 1);
    }
    cronJobs.get(mes_id + "-start")?.stop();
    cronJobs.get(mes_id + "-end")?.stop();
}

async function scheduleCronJob(datapointTimer: DatapointTimer, host: string) {
    const { mes_id, startTime, endTime, active } = datapointTimer;
    const date = new Date(datapointTimer.date);
    const dateExpression = `${date.getDate()} ${date.getMonth() + 1} *`;
    const [startHours, startMinutes] = startTime.split(':').map(Number);
    const cronStartExpression = `${startMinutes} ${startHours} ${dateExpression}`;

    const [endHours, endMinutes] = endTime.split(':').map(Number);
    const cronEndExpression = `${endMinutes} ${endHours} ${dateExpression}`;
    console.log(`Cron start expression: ${cronStartExpression}`);
    console.log(`Cron start expression: ${cronEndExpression}`);
    const startJob = cron.schedule(cronStartExpression, async () => {
        const res = await fetch(`http://${host}/api/scada/login`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username: "admin", password: "admin" }),
        });
        const cookie = await res.headers.get("set-cookie") || "";
        fetch(`http://${host}/api/scada/set_datapoint`, {
            method: "POST",
            headers: { "Content-Type": "application/json", Cookie : cookie },
            body: JSON.stringify({ xid: datapointTimer.xid, value: !!active }),
        });
        cronJobs.get(mes_id + "-start")?.stop();
    });
    const endJob = cron.schedule(cronEndExpression, async () => {
        const res = await fetch(`http://${host}/api/scada/login`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username: "admin", password: "admin" }),
        });
        const cookie = await res.headers.get("set-cookie") || "";
        fetch(`http://${host}/api/scada/set_datapoint`, {
            method: "POST",
            headers: { "Content-Type": "application/json", Cookie : cookie },
            body: JSON.stringify({ xid: datapointTimer.xid, value: !active }),
        });
        cronJobs.get(mes_id + "-end")?.stop();
        datapointTimers.splice(datapointTimers.findIndex( (datapointTimer) => datapointTimer.mes_id === mes_id ), 1);
    });

    cronJobs.set(mes_id + "-start", startJob);
    cronJobs.set(mes_id + "-end", endJob);
}