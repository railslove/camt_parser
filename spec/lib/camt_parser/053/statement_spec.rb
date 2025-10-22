require 'spec_helper'

describe CamtParser::Format053::Statement do
  let(:camt)       { CamtParser::File.parse('spec/fixtures/valid_example.xml') }
  let(:statements) { camt.statements }
  let(:ex_stmt)    { camt.statements[0] }

  specify { expect(statements).to all(be_kind_of(described_class)) }
  specify { expect(ex_stmt.identification).to eq("0352C5320131227220503") }
  specify { expect(ex_stmt.generation_date).to be_kind_of(Time) }
  specify { expect(ex_stmt.from_date_time).to be_nil }
  specify { expect(ex_stmt.to_date_time).to be_nil }
  specify { expect(ex_stmt.account).to be_kind_of(CamtParser::Format053::Account) }
  specify { expect(ex_stmt.entries).to be_kind_of(Array) }
  specify { expect(ex_stmt.electronic_sequence_number).to eq('130000005') }

  specify { expect(ex_stmt.opening_balance).to be_kind_of(CamtParser::Format053::AccountBalance) }
  specify { expect(ex_stmt.closing_balance).to be_kind_of(CamtParser::Format053::AccountBalance) }

  specify { expect(ex_stmt.identification).to eq("0352C5320131227220503") }
end

describe "parsing 11_EBICS_camt.053_Kontoauszug_mit_allen_Umsaetzen.xml" do
  let(:camt)       { CamtParser::File.parse('spec/fixtures/11_EBICS_camt.053_Kontoauszug_mit_allen_Umsaetzen.xml') }
  let(:statements) { camt.statements }
  let(:ex_stmt)    { camt.statements[0] }

  it "parses statement identification" do
    expect(ex_stmt.identification).to eq("20240313C0098170")
  end

  it "parses account IBAN" do
    expect(ex_stmt.account.iban).to eq("DE00IBANdesDotationskontos")
  end

  it "parses opening and closing balances" do
    expect(ex_stmt.opening_balance).to be_kind_of(CamtParser::Format053::AccountBalance)
    expect(ex_stmt.opening_balance.amount).to eq(0.00)
    expect(ex_stmt.closing_balance).to be_kind_of(CamtParser::Format053::AccountBalance) 
    expect(ex_stmt.closing_balance.amount).to eq(0.00)
  end

  it "parses all entries" do
    expect(ex_stmt.entries.size).to eq(11)
    amounts = ex_stmt.entries.map(&:amount)
    expect(amounts).to include(100000.00, 25000.00, 20000.00, 15.00, 145015.00, 50000.00, 80000.00, 30000.00, 120000.00, 280000.00)
  end

  it "parses entry credit/debit indicators" do
    expect(ex_stmt.entries.map(&:credit?)).to include(true, false)
    expect(ex_stmt.entries.map(&:debit?)).to include(true, false)
  end
end
