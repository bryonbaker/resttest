FROM alpine:latest
COPY ./restest /bin/
WORKDIR "/bin"
EXPOSE 8000
CMD ["restest"]
