module.exports = {
    GA4_EVENTS_TABLE: 'easyvending-418607.analytics_340241924.events_*',
    GCLID_SOURCE_TABLE: 'easyvending-418607.marketing_data.raw_gads_click_view',
    DOMAIN_REGEX: 'easyvending',
    UTC_OFFSET_HOURS: 2, // utc + 2 hours in microseconds (2 * 60 * 60 * 1000000)
    ATTRIBUTION_WINDOW_DAYS: 90,
    BANNED_EVENTS: [
        'scroll2',
        'select_item2'
    ],
    KEY_EVENTS: [
        'purchase',
        'phone_number_click',
        'callback_request',
        'email_subscription',
        'representative_form',
        'prices_form',
        'product_request',
        'qualified_lead',
        'Bitrix24ChatOpen_click',
        'add_to_cart'
    ]
};
