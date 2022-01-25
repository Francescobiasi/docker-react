#file docker per generare l'immagine in ambiente produzione
#1)abbiamo bisogno di due fasi, la prima che scarichi le dipendenze e langi il comando npm build che permette di generare i file minimi per il funzionamento dell applicazione
#2)dobbiamo eseguire nginx dando in pasto il contenuto generato dallo step 1
FROM node:16-alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .

RUN npm run build  

#in questo modo non prendiamo altri file se non quelli dentro la cartellina build
# tutto il contenuto lo avremo dentro app/build
#secondo blocco, ogni blocco ha un solo comando di FROM
FROM nginx
#stiamo dicendo: prendi il contenuto dell'immagine precedente --from=builder, il contenuto si trova dentro /app/build e lo inserire nella cartella (specificata dall immagine ufficiale di nginx) 
COPY --from=builder /app/build /usr/share/nginx/html 

#non serve specificare il comando perchè si arrangia nginx