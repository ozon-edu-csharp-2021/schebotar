FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src/
COPY ["./src/OzonEdu.MerchApi/OzonEdu.MerchApi.csproj","."]
RUN dotnet restore "./OzonEdu.MerchApi.csproj"
COPY . . 
RUN dotnet build "OzonEdu.MerchApi.csproj" -c Release -o /app/build

FROM build as publish
RUN dotnet publish "OzonEdu.MerchApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS runtime
WORKDIR /app

EXPOSE 80
EXPOSE 443

FROM runtime as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OzonEdu.MerchApi.dll"]