local Translations = {
    error = {
        not_in_vehicle = 'You must be in a vehicle to install a harness',
        wrong_class = 'You cannot install a harness in this type of vehicle',
        canceled_installation = 'Canceled installation',
        already_installed = 'You already have a harness installed',
        no_harness = 'This vehicle doesn\'t even have a harness',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
