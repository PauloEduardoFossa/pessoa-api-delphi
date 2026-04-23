unit uConstants;

interface

const
  CONSULTA_PESSOA =
      'SELECT ' +
      ' idpessoa , ' +
      ' flnatureza , ' +
      ' dsdocumento , ' +
      ' nmprimeiro , ' +
      ' nmsegundo , ' +
      ' dtregistro  ' +
      'FROM pessoa ';

  FILTRO_PESSOA = ' WHERE idpessoa = :idpessoa ';

  INSERT_PESSOA =
      'INSERT INTO pessoa ' +
      '(dtregistro , flnatureza , dsdocumento , nmprimeiro , nmsegundo) ' +
      'VALUES (:dtregistro, :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo)';

  DELETE_PESSOA = 'DELETE FROM pessoa WHERE idpessoa = :idpessoa';

  UPDATE_PESSOA =
        'UPDATE pessoa ' +
        'SET flnatureza = :flnatureza, ' +
        '    dsdocumento = :dsdocumento, ' +
        '    nmprimeiro = :nmprimeiro, ' +
        '    nmsegundo = :nmsegundo ' +
        'WHERE idpessoa = :idpessoa ';



  CONSULTA_ENDERECO =
      'SELECT ' +
      ' idendereco,'+
      ' idpessoa, ' +
      ' dscep '+
      'FROM endereco ';

  FILTRO_ENDERECO = ' WHERE idpessoa = :idpessoa';

  INSERT_ENDERECO =
      'INSERT INTO endereco ' +
      '(idpessoa, dscep) ' +
      'VALUES (:idpessoa, :dscep)';

  UPDATE_ENDERECO =
        'UPDATE endereco ' +
        'SET dscep = :dscep ' +
        'WHERE idpessoa = :idpessoa ';


  INSERT_PESSOA_LOTE =
      'INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ' +
      'VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro)';

  INSERT_ENDERECO_LOTE =
      'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep)';

  CONSULTA_ENDERECO_CEP =
      'SELECT idendereco, dscep ' +
      'FROM endereco ' +
      'WHERE dscep IS NOT NULL ' +
      '  AND TRIM(dscep) <> ''''';

implementation

end.
