create database aulaex8
use aulaex8

create table produtos(
	cod			int				not null,
	produto		varchar(90)		not null,
	preco		decimal(7,2)	not null,
	quantidade	int				not null
	primary key(cod)
);
insert into produtos values (1,'Mouse',500.00,1);

select 
	cod		   as 'Código do produto',
	produto    as 'Produto',
	preco	   as 'Preço',
	quantidade as 'Quantidade'
from produtos

create table clientes(
	cod			int				not null,
	cliente		varchar(90)		not null,
	limitecred	decimal(7,2)	not null
	primary key (cod)
);
insert into clientes values (1,'Joãozinho',2500.00);

select 
	cod				as 'Código do produto',
	cliente			as 'Cliente',
	limitecred	    as 'Limite de crédito'
from clientes

create table vendas(
	datavend	datetime		not null,
	cliente		varchar(90)		not null,
	valor		decimal(7,2)	not null
);

create table entradas(
    codproduto	int not null,
    produto		varchar(90) not null,
    quantidade	int not null,
    dataentrada datetime not null,
    primary key(codproduto)
);

go
create procedure atualizacoes
	@cod			int,
	@produto		varchar(90),
	@preco			decimal(7,2),
	@quantidade		int,
	@datavend		datetime,
	@precoatt		decimal(7,2),
	@codatt			int,
	@porcentagem	decimal(5,2),	
	@codcliente		int,			
	@valorcompra	decimal(7,2),	
	@produtoVenda	varchar(90),	
	@qtdVenda		int				
as
begin
	declare @quantidadeAtual int;
	declare @precoAtual decimal(7,2);
	declare @precoNovo decimal(7,2);
	declare @limiteCredito decimal(7,2);
	declare @valorTotal decimal(7,2);

	select @quantidadeAtual = quantidade, @precoAtual = preco
	from produtos
	where cod = @cod;

	if @quantidadeAtual = @quantidadeAtual  
	begin
		
		if @datavend <> ''
		begin
			
			if @quantidadeAtual >= @quantidade
			begin
				update produtos
				set quantidade = quantidade - @quantidade
				where cod = @cod;

				print 'Saída realizada com sucesso.';
			end
			else
			begin
				print 'Erro: estoque insuficiente.';
			end
		end
		else
		begin
			
			update produtos
			set quantidade = quantidade + @quantidade
			where cod = @cod;

			print 'Entrada realizada com sucesso.';
		end

		if @porcentagem <> 0
		begin
			
			set @precoNovo = @precoAtual + (@precoAtual * @porcentagem / 100);

			update produtos
			set preco = @precoNovo
			where cod = @cod;

			print 'Preço atualizado com sucesso.';
		end

		update produtos
		set preco = @precoatt,
			cod = @codatt
		where cod = @cod;
	end
	else
	begin
		print 'Produto não encontrado.';
	end

	if @valorcompra > 0
	begin
		
		select @limiteCredito = limitecred
		from clientes
		where cod = @codcliente;

		if @limiteCredito = @limiteCredito 
		begin
			if @valorcompra <= @limiteCredito
			begin
				
				insert into vendas (datavend, cliente, valor)
				values (@datavend, @codcliente, @valorcompra);

				print 'Venda 1 realizada com sucesso.';
			end
			else
			begin
				print 'Erro: valor da compra excede o limite de crédito do cliente.';
			end
		end
		else
		begin
			print 'Erro: cliente não encontrado.';
		end
	end

	if @produtoVenda <> '' and @qtdVenda > 0
	begin
		
		select @limiteCredito = limitecred
		from clientes
		where cod = @codcliente;

		if @limiteCredito = @limiteCredito
		begin
			
			select @precoAtual = preco
			from produtos
			where produto = @produtoVenda;

			if @precoAtual = @precoAtual
			begin
				
				set @valorTotal = @qtdVenda * @precoAtual;

				if @valorTotal <= @limiteCredito
				begin
					
					insert into vendas (datavend, cliente, valor)
					values (@datavend, @codcliente, @valorTotal);

					print 'Venda 2 realizada com sucesso.';
				end
				else
				begin
					print 'Erro: valor da compra excede o limite de crédito do cliente.';
				end
			end
			else
			begin
				print 'Erro: produto não cadastrado.';
			end
		end
		else
		begin
			print 'Erro: cliente não cadastrado.';
		end
	end
end;

exec atualizacoes 
	@cod = 1, 
	@produto = 'Mouse', 
	@preco = 500.00, 
	@quantidade = 2, 
	@datavend = '2025-05-20', 
	@precoatt = 550.00, 
	@codatt = 1,
	@porcentagem = 10.00, 
	@codcliente = 1, 
	@produtoVenda = 'Mouse', 
	@qtdVenda = 3; 


create table entradas(
    codproduto int not null,
    produto varchar(90) not null,
    quantidade int not null,
    dataentrada datetime not null,
    primary key(codproduto, dataentrada)
);

create procedure gerenciamentoprod
    @codproduto int,
    @produto varchar(90),
    @quantidade int,
    @preco decimal(7,2),
    @datavend datetime,
    @precoatt decimal(7,2),
    @codatt int,
    @porcentagem decimal(5,2),
    @codcliente int,
    @valorcompra decimal(7,2),
    @produtoVenda varchar(90),
    @qtdVenda int
as
begin
  
    declare @quantidadeAtual int;
    declare @precoAtual decimal(7,2);
    declare @precoNovo decimal(7,2);
    declare @limiteCredito decimal(7,2);
    declare @valorTotal decimal(7,2);

    insert into entradas (codproduto, produto, quantidade, dataentrada)
    values (@codproduto, @produto, @quantidade, getdate());

    print 'Entrada registrada com sucesso.';

    select @quantidadeAtual = quantidade, @precoAtual = preco
    from produtos
    where cod = @codproduto;

    select
        sum(quantidade) as Total_Quantidade,
        sum(quantidade * preco) as Valor_Estoque
    from produtos
    where cod = @codproduto;

    if @valorcompra > 0
    begin
        select @limiteCredito = limitecred
        from clientes
        where cod = @codcliente;

        if @limiteCredito = @limiteCredito
        begin
            if @valorcompra <= @limiteCredito
            begin
                insert into vendas (datavend, cliente, valor)
                values (@datavend, @codcliente, @valorcompra);

                print 'Venda 1 realizada com sucesso.';
            end
            else
            begin
                print 'Erro: valor da compra excede o limite de crédito do cliente.';
            end
        end
        else
        begin
            print 'Erro: cliente não encontrado.';
        end
    end

    if @produtoVenda <> '' and @qtdVenda > 0
    begin
        select @limiteCredito = limitecred
        from clientes
        where cod = @codcliente;

        if @limiteCredito = @limiteCredito
        begin
            select @precoAtual = preco
            from produtos
            where produto = @produtoVenda;

            if @precoAtual = @precoAtual
            begin
                set @valorTotal = @qtdVenda * @precoAtual;

                if @valorTotal <= @limiteCredito
                begin
                    insert into vendas (datavend, cliente, valor)
                    values (@datavend, @codcliente, @valorTotal);

                    print 'Venda 2 realizada com sucesso.';
                end
                else
                begin
                    print 'Erro: valor da compra excede o limite de crédito do cliente.';
                end
            end
            else
            begin
                print 'Erro: produto não cadastrado.';
            end
        end
        else
        begin
            print 'Erro: cliente não cadastrado.';
        end
    end

    select 
        count(*) as Total_Produtos, 
        sum(preco) as Total_Valor, 
        avg(preco) as Preco_Medio
    from produtos;

    declare @contador int = 1;
    declare @totalProdutos int;
    
    select @totalProdutos = count(*) from produtos;

    while @contador <= @totalProdutos
    begin
        declare @produtoNome varchar(90);
        declare @produtoQuantidade int;
        
        select @produtoNome = produto, @produtoQuantidade = quantidade
        from produtos
        where cod = @contador;

        print 'Produto: ' + @produtoNome + ', Quantidade: ' + cast(@produtoQuantidade as varchar);

        set @contador = @contador + 1;
    end
end;

exec gerenciamentoprod
	@codproduto = 1, 
	@produto = 'Mouse', 
	@quantidade = 10, 
	@preco = 100.00, 
	@datavend = '2025-05-20', 
	@precoatt = 110.00, 
	@codatt = 1, 
	@porcentagem = 5.00, 
	@codcliente = 1, 
	@valorcompra = 200.00, 
	@produtoVenda = 'Mouse', 
	@qtdVenda = 3;

