FROM alpine
RUN apk add git

ADD publish-chart.sh /bin/
CMD [ "/bin/publish-chart.sh" ]
