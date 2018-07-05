//
//  GeradorDePagamentoTests.swift
//  LeilaoTests
//
//  Created by Alura Laranja on 11/06/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class GeradorDePagamentoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDeveGerarPagamentoParaUmLeilaoEncerrado() {
        
        let playstation = CriadorDeLeilao().para(descricao: "Playstation")
            .lance(Usuario(nome: "José"), 2000.0)
            .lance(Usuario(nome: "Maria"), 2500.0)
            .constroi()
        
        let daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.encerrados()).thenReturn([playstation])
        }
        
        let avaliadorFalso = Avaliador()
        
        let pagamentos = MockRepositorioDePagamento().withEnabledSuperclassSpy()
        
        let geradorDePagamento = GeradorDePagamento(daoFalso, avaliadorFalso, pagamentos)
        geradorDePagamento.gera()
        
        let capturadorDeArgumento = ArgumentCaptor<Pagamento>()
        verify(pagamentos).salva(capturadorDeArgumento.capture())
        
        let pagamentoGerado = capturadorDeArgumento.value
        
        XCTAssertEqual(2500.0, pagamentoGerado?.getValor())
    }
    
}











