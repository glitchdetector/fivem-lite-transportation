local CURRENT_JOB = {}

function GetCurrentJob()
    return CURRENT_JOB
end

function IsOnJob(type)
    if type then
        return CURRENT_JOB.active and CURRENT_JOB.type == type
    end
    return CURRENT_JOB.active
end

local function setAllJobBlipsAlpha(alpha)
    for _, poi in next, POI do
        if poi.job then
            if poi.blip then
                SetBlipAlpha(poi.blip, alpha)
            end
        end
    end
end

function ShowAllJobs()
    if not IsOnJob() then
        setAllJobBlipsAlpha(255)
    end
end

function HideAllJobs()
    setAllJobBlipsAlpha(0)
end

function ClearJob(job)
    log("clearing job data")
    if job.blip then
        RemoveBlip(job.blip)
        job.blip = nil
    end
end

function StopJob()
    log("stopping old job")
    if IsOnJob() then
        for _, job in next, CURRENT_JOB.deliveries do
            ClearJob(job)
        end
    end
    CURRENT_JOB = {}
    ShowAllJobs()
end

function AddJob(job)
    if IsOnJob() then
        log("adding new destination to job")
        CURRENT_JOB.name = job.name
        CURRENT_JOB.totalPay = CURRENT_JOB.totalPay + job.pay
        local blip = AddBlipForCoord(job.pos)
        SetBlipSprite(blip, 525)
        SetBlipName(blip, "~y~Active Job~s~: " .. job.name)
        SetBlipRoute(blip, true)
        job.blip = blip
        table.insert(CURRENT_JOB.deliveries, job)
    end
end

function StartJob(type, job)
    StopJob()
    log("starting new " .. type .. " job")
    CURRENT_JOB.active = true
    CURRENT_JOB.type = type
    CURRENT_JOB.name = ""
    CURRENT_JOB.totalPay = 0
    CURRENT_JOB.deliveries = {}
    AddJob(job)
    HideAllJobs()
end
