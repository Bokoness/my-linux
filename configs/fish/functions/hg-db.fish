function connect_hg_db
    ssh -L 3307:bo-mysql-1-2021-02-02.crmg6rxqqxbh.eu-central-1.rds.amazonaws.com:3306 ness@3.122.222.124 -N
end
