```vhdl
ENTITY register_file IS
  GENERIC (data_width : INTEGER := 32; addr_width : INTEGER := 5);
  PORT (
    clk : IN STD_LOGIC;
    wr_en : IN STD_LOGIC;
    wr_addr : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
    wr_data : IN STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
    rd_addr1 : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
    rd_addr2 : IN STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
    rd_data1 : OUT STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
    rd_data2 : OUT STD_LOGIC_VECTOR(data_width-1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE behavioral OF register_file IS
  TYPE reg_array IS ARRAY (0 TO (2**addr_width - 1)) OF STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
  SIGNAL registers : reg_array := (OTHERS => (OTHERS => '0'));
  SIGNAL wr_addr_int : INTEGER;
  SIGNAL rd_addr1_int : INTEGER;
  SIGNAL rd_addr2_int : INTEGER;
BEGIN
  -- Integer conversion with range check
  wr_addr_int <= to_integer(unsigned(wr_addr));
  rd_addr1_int <= to_integer(unsigned(rd_addr1));
  rd_addr2_int <= to_integer(unsigned(rd_addr2));

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF wr_en = '1' AND wr_addr_int >= 0 AND wr_addr_int < 2**addr_width THEN
        registers(wr_addr_int) <= wr_data;
      END IF;
    END IF;
  END PROCESS;
  
  -- Range check before accessing the array
  rd_data1 <= registers(rd_addr1_int) WHEN rd_addr1_int >= 0 AND rd_addr1_int < 2**addr_width ELSE (others => '0');
  rd_data2 <= registers(rd_addr2_int) WHEN rd_addr2_int >= 0 AND rd_addr2_int < 2**addr_width ELSE (others => '0');
END ARCHITECTURE; 
```