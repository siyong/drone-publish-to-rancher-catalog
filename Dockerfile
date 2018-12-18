FROM alpine/git

ADD publish-chart.sh /bin/
CMD [ "/bin/publish-chart.sh" ]
