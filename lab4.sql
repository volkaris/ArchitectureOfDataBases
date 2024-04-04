
 CREATE EXTENSION IF NOT EXISTS anon CASCADE;
SELECT anon.start_dynamic_masking();


SECURITY LABEL FOR anon ON COLUMN postgres.public.clients."First_Name"
    IS 'MASKED WITH FUNCTION anon.fake_last_name()';

SECURITY LABEL FOR anon ON COLUMN postgres.public.clients."Last_Name"
    IS 'MASKED WITH FUNCTION anon.fake_last_name()';




SECURITY LABEL FOR anon ON COLUMN postgres.public.country.name
     IS 'MASKED WITH FUNCTION anon.fake_country()';

 SECURITY LABEL FOR anon ON COLUMN postgres.public.country.state
     IS 'MASKED WITH FUNCTION anon.fake_city()';


 create materialized view clients_anonimized_materialized_view as
 SELECT clients."First_Name",
        clients."Last_Name",
        anon.generalize_int8range(accounts.balance::integer::bigint, 2000::bigint) AS money_amount,
        account_types.type
 FROM accounts
          JOIN clients ON accounts.client_id = clients.clients_id
          JOIN account_types ON accounts.type_id = account_types.type_id;

 alter materialized view clients_anonimized_materialized_view owner to postgres;


 create materialized view  transaction_view(date, currency, "operation description", "transaction description") as
 SELECT anon.dnoise(transactions.date, '10 years'),

        'CONFIDENTIAL'                 AS currency,
        operation_desc.description     AS "operation description",
        'DATA DELETED' AS "transaction description"
 FROM transactions
          JOIN operation_desc ON transactions.operation_id = operation_desc.operation_id
          JOIN transaction_status ON transactions.status_id = transaction_status.status_id
          JOIN currency ON transactions.currency_id = currency.id;


select from_currency_id as "from",to_currency_id as "to",rate,starting_date,ending_date,name
from currency_rate join public.currency c on currency_rate.from_currency_id = c.id;



 CREATE MATERIALIZED VIEW currency_materialized_view AS
 SELECT
     c1.name AS from_currency_name,
     c2.name AS to_currency_name,
     anon.noise(rate, 0.5) as rate ,
     anon.random_date() AS starting_date,
     anon.random_date() AS ending_date
 FROM currency_rate
          JOIN public.currency c1 ON currency_rate.from_currency_id = c1.id
          JOIN public.currency c2 ON currency_rate.to_currency_id = c2.id;
