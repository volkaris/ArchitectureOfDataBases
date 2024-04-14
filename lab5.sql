create table last_name_from_a_to_d (check ("Last_Name" like any (array ['A%','B%','C%','D%']) ))
    inherits (clients);

create table last_name_from_e_to_h (check ("Last_Name" like any (array ['E%','F%','G%','H%']) ))
    inherits (clients);


create table last_name_from_i_to_l (check ("Last_Name" like any (array ['I%','J%','K%','L%']) ))
    inherits (clients);


create table last_name_from_m_to_p (check ("Last_Name" like any (array ['M%','N%','O%','P%']) ))
    inherits (clients);


create table last_name_from_q_to_t (check ("Last_Name" like any (array ['Q%','R%','S%','T%']) ))
    inherits (clients);


create table last_name_from_u_to_w (check ("Last_Name" like any (array ['U%','V%','W%']) ))
    inherits (clients);


create table last_name_from_x_to_z (check ("Last_Name" like any (array ['X%','Y%','Z%']) ))
    inherits (clients);


create or replace function
    clients_inherit_trigger()
    returns trigger as $$
begin
    if (new."Last_Name" like any (array ['A%','B%','C%','D%']))
        then insert into last_name_from_a_to_d values (new.*);


    elseif (new."Last_Name" like any (array ['E%','F%','G%','H%']))
    then insert into last_name_from_e_to_h values (new.*);


    elseif (new."Last_Name" like any (array ['I%','J%','K%','L%']))
    then insert into last_name_from_i_to_l values (new.*);

    elseif (new."Last_Name" like any (array ['Q%','R%','S%','T%']))
    then insert into last_name_from_q_to_t values (new.*);


    elseif (new."Last_Name" like any (array ['U%','V%','W%']))
    then insert into last_name_from_u_to_w values (new.*);

    elseif (new."Last_Name" like any (array ['X%','Y%','Z%']))
    then insert into last_name_from_x_to_z values (new.*);

    else
        raise exception 'How did you even managed to create something out of english alphabet?';
    end if;
    return null;
end;
$$
    language plpgsql;


create trigger insert_in_clients
    before insert on clients
    for each row execute function
clients_inherit_trigger();
