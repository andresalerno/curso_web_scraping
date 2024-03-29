setwd("~/cursos/curso-r/web_scraping")

library(httr)
library(xml2)

# primeiro passo: requisição
req <- GET("http://example.webscraping.com/")

# segundo passo: transformar a requisição em conteúdo html (texto contendo os dados)
html <- read_html(req)
html <- content(req)

#content é uma função em requisição (resultado de GET e de POST)

# outro jeito de fazer: html <- read_html("http://example.webscraping.com/")

# terceiro passo: decidir o que é que eu quero analisar ou aonde podar a árvore

# passo 3.1: chutar seletores (xpath ou css)

# primeiro chute: //*[@id="results"]/table/tbody/tr[1]/td[2]/div/a (está errado)
# //*[@id="results"]/table/tbody/tr[1]
# //*[@id="results"]/table/tbody/tr[1]/td[1]/div/a


# opcao 1: seguindo o chrome
xml_find_all(html, "//*[@id='results']/table/tr/td/div/a")

# opcao 2: segue o crome até um pedaço e depois pega os filhos no R
divs_filhos_de_td <- xml_find_all(html, "//*[@id='results']/table/tr/td/div")

xml_children(divs_filhos_de_td)

# opcao 3: encurtar ao máximo a query
tags_a <- xml_find_all(html, "//td//a")
tags_img <- xml_find_all(html, "//td//a/img")

# quarto passo: extrair dos nós que eu tenho interesse as informações relevantes

# passo 4.1: pegar os links

links <- unlist(xml_attrs(tags_a))

links <- xml_attr(tags_a, "href")

links_completo <- paste0("http://example.webscraping.com", links)

# passo 4.2: pegar os textos

textos <- xml_text(tags_a)

# passo 4.3: pegar os src das imagens

imagens <- xml_attr(tags_img, "src")

# quinto passo: montar o data.frame

df <- data.frame(
  coluna_link = links_completo,
  coluna_nome_pais = textos,
  coluna_imagens = imagens
)