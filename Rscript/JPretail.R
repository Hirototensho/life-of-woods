# 商業動態統計 販売額 単位10億円
JPretail_code <- read_csv("input/分類コード - 分類コード.csv")
JPretail_row <- read_csv("input/h2slt11j.xls - 販売額（value） (月次M).csv", skip = 8,
                         na = "…")

JPretail_row <- JPretail_row %>% select(-X1)

# 変数名を変更します。
names(JPretail_row) <-pull(JPretail_code, 分類名)

JPretail_row <- JPretail_row %>% 
  fill(年, .direction = "down")

JPretail_row <- 
  JPretail_row %>%
  mutate(
    月 =  rep(1:12, length = nrow(JPretail_row)),
    日 = 1
  ) %>%
  unite(年, 月,日,col = "年月", sep = "-") %>%
  mutate(年月 = as_date(年月)) %>%
  select(年月, everything())

JPretail_row <- JPretail_row %>% select(年月:`無店舗 - 小売業`) # 不必要な行を除外します

#比較的簡単な方法でnaをドロップしてみる 

JPretail_row <-
  JPretail_row %>% 
  fill(年月:`無店舗 - 小売業`, .direction = "up") %>%
  drop_na() 

JPretail <-
  JPretail_row %>%
  gather(`商業計 - 商業計`:`無店舗 - 小売業`, key = "分類名", value = "販売額") %>%
  arrange(年月)

JPretail <- 
  left_join(JPretail,JPretail_code, by = "分類名")  %>%
  separate(分類名, into = c("小分類", "大分類"), sep = " - ") %>%
  mutate(
    小分類 = fct_reorder(小分類, 分類コード)
  ) 










