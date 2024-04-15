use bankDb

db.createCollection("currency_rate");
db.createCollection("currency");
db.createCollection("transactions");
db.createCollection("bank_document");
db.createCollection("transaction_status");
db.createCollection("operation_desc");
db.createCollection("accounts");
db.createCollection("clients");
db.createCollection("account_types");

db.currency.insertMany( [
{name : "Ruble",
_id : 1},

{name : "Dollar",
_id : 2},

{name : "Euro",
_id : 3}
 ]  )

 db.currency_rate.insertMany(
 [ {from_currency_id : 1,
   to_currency_id:2,
   rate: 100,
   starting_date : ISODate("2022-01-08"),
   ending_date : ISODate("2024-01-08"),
   _id:1  },

 {from_currency_id :2,
    to_currency_id:3,
    rate: 1,
    starting_date : ISODate("2022-01-08"),
    ending_date : ISODate("2024-01-08"),
    _id:2},

    {from_currency_id : 1,
       to_currency_id:3,
       rate: 150,
       starting_date : ISODate("2022-01-08"),
       ending_date : ISODate("2024-01-08"),
       _id:3  },
 ]
 )

db.transactions.insertMany(
 [ {bank_document_id: 100,
    operation_id : 1,
    date:ISODate("2022-01-08"),
    status_id :1,
    currency_id: 1,
    _id:1},

    {bank_document_id: 101,
        operation_id : 2,
        date:ISODate("2032-01-08"),
        status_id :2,
        currency_id: 2,
        _id:2},

    {bank_document_id: 102,
        operation_id : 3,
        date:ISODate("2332-01-08"),
        status_id :3,
        currency_id: 3,
        _id:3},
 ])

db.bank_document.insertMany( [

{
    sender_id:100,
    receiver_id:101,
    _id:1
},

{
    sender_id:101,
    receiver_id:102,
    _id:2
},

{
    sender_id:101,
    receiver_id:102,
    _id:3
},
])

db.transaction_status.insertMany( [

{
description:"Approved",
_id:1
},
{
description:"Rejected",
_id:2
},
{
description:"Processing",
_id:3
},
])


db.operation_desc.insertMany( [

{
description: "Adding",
_id:1
},

{
description: "Substracting",
_id:2
},

{
description: "Transferring",
_id:3
},

])


db.account_types.insertMany( [

{type: "Debit",
_id: 1},

{type: "Credit",
_id: 2},
{type: "Commision",
_id: 3},
])

db.clients.insertMany([
                           	{
                           		"_id": 1,
                           		"First_Name": "Holland",
                           		"Second_Name": "Kinney"
                           	},
                           	{
                           		"_id": 2,
                           		"First_Name": "Ramirez",
                           		"Second_Name": "Howe"
                           	},
                           	{
                           		"_id": 3,
                           		"First_Name": "Mitchell",
                           		"Second_Name": "Parsons"
                           	},
                           	{
                           		"_id": 4,
                           		"First_Name": "Mcclure",
                           		"Second_Name": "Kane"
                           	},
                           	{
                           		"_id": 5,
                           		"First_Name": "Saunders",
                           		"Second_Name": "Miles"
                           	}
                           ])

db.accounts.insertMany([
{
    balance:100500,
    client_id:2,
    type_id: 1,
    _id:100
},
{
    balance:500,
    client_id:1,
    type_id: 2,
    _id:101
},
{
    balance:1050000,
    client_id:3,
    type_id: 3,
    _id:102
},
 ])

db.accounts.createIndex({client_id:1,type_id:1});

db.createView("accountsWithClients",
              "accounts",
              [ {
                    $lookup : {
                                from: "clients",
                                localField: "client_id",
                                foreignField : "_id",
                                as : "client" }
              },
              {
                    $lookup : {
                                from: "account_types",
                                localField: "type_id",
                                foreignField : "_id",
                                as : "account_type" }

              },
              {
                    $project:{  "client.First_Name" : 1,
                                "client.Second_Name" : 1,
                                balance : 1,
                                "account_type.type" : 1,
                                _id :0
                }
              }
              ])

