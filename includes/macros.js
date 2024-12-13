function empty_or_not_set_to_null(column_name) {
    return `IF(${column_name} = '' OR ${column_name} = '(not set)', NULL, ${column_name}) AS ${column_name}`;
}

function generate_deterministic_id(...fields) {
    const fieldStr = fields.map(f => `COALESCE(CAST(${f} AS STRING), '')`).join(', ');
    return `CAST(LPAD(SUBSTR(TO_HEX(MD5(CONCAT(${fieldStr}))), 1, 12), 14, '0') AS STRING)`;
}

function remove_url_params(url, additional_params = []) {
    const default_params = ['gclid', 'wbclid', 'gad_source', 'sphrase_id', 'gbraid', 'fbclid', 'srsltid'];
    const all_params = [...default_params, ...additional_params];
    
    return `
    (
        SELECT
            IF(ARRAY_LENGTH(
                ARRAY(
                    SELECT param_value
                    FROM UNNEST(SPLIT(SPLIT(${url}, '?')[SAFE_OFFSET(1)], '&')) AS param_value
                    WHERE 
                        SPLIT(param_value, '=')[OFFSET(0)] NOT IN (${all_params.map(p => `'${p}'`).join(',')})
                        AND NOT STARTS_WITH(SPLIT(param_value, '=')[OFFSET(0)], 'utm_')
                )
            ) > 0,
            CONCAT(
                SPLIT(${url}, '?')[OFFSET(0)],
                '?',
                ARRAY_TO_STRING(
                    ARRAY(
                        SELECT param_value
                        FROM UNNEST(SPLIT(SPLIT(${url}, '?')[SAFE_OFFSET(1)], '&')) AS param_value
                        WHERE 
                            SPLIT(param_value, '=')[OFFSET(0)] NOT IN (${all_params.map(p => `'${p}'`).join(',')})
                            AND NOT STARTS_WITH(SPLIT(param_value, '=')[OFFSET(0)], 'utm_')
                    ),
                    '&'
                )
            ),
            SPLIT(${url}, '?')[OFFSET(0)]
        )
    )`;
}

function join_array(arr, quote = '') {
    return arr.map(item => `${quote}${item}${quote}`).join(',');
}

module.exports = {
    empty_or_not_set_to_null,
    generate_deterministic_id,
    remove_url_params,
    join_array
};