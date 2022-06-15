# test

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


```mermaid

classDiagram
%% =======================================
%% Views
%% =======================================
class LandingView{
    +Widget build()
}
class DetailView{
    +Widget build()
}
class DashboardView{
    +Widget build()
}
class PortfolioView{
    +Widget build()
}
class StatsListView{
    +Widget build()
}
class BlockStatsDetailView{
    +Widget build()
}
class DappsStakingDetailView{
    +Widget build()
}
class DeFiDetailView{
    +Widget build()
}
class NftDetailView{
    +Widget build()
}
class WalletConnectView{
    +Widget build()
}


%% =======================================
%% Provider
%% =======================================
class StatsListProvider{
    +StatModel[] statModelList
}
class PortfolioProvider{
    +Portfolio[] PortfolioModelList
    +String waleltID
}

class BlockStatsDetailProvider{
    +BlockStatsModel[] blockStatsModelList
}

class DappsStakingDetailProvider{
    +DappsStakingModel[] dappsStakingModelList
}

class DeFiDetailProvider{
    +DeFiModel[] deFiModelList
}

class NftDetailProvider{
    +NftModel[] nftModelList
}

%% =======================================
%% Repository
%% =======================================
class BlockStatsRepository{
    <<singleton>>
    -BlockStatsModel[] _modelList
    +BlockStatsModel[] modelList => _modelList
    + update()
    +StatsModel[] getAsStatsModel(BlockStatsModel)
}

class TokenRepository{
    <<singleton>>
    -TokenModel[] _modelList
    +TokenModel[] modelList => _modelList
    + update()
    +PortfolioModel[] getAsPortfolioModel(TokenModel)
}

class DappsStakingRepository{
    <<singleton>>
    -DappsStakingModel[] _model
    +DappsStakingModel[] modelList => _modelList
    + update()
    +PortfolioModel[] getAsPortfolioModel(DappsStakingModel)
    +StatsModel[] getAsStatsModel(DappsStakingModel)
}
class DeFiRepository{
    <<singleton>>
    -DeFiModel[] _modelList
    +DeFiModel[] modelList => _modelList
    + update()
    +PortfolioModel[] getAsPortfolioModel(DeFiModel)
    +StatsModel[] getAsStatsModel(DeFiModel)
}

class NftRepository{
    <<singleton>>
    -NftModel[] _modelList
    +NftModel[] modelList => _modelList
    + update()
    +PortfolioModel getAsPortfolioModel(NftModel)
    +StatsModel getAsStatsModel(NftModel)
}

%% =======================================
%% Endpoint
%% =======================================
class BlockStatsEndpoint{
    +Map download()
    +BlockStatsModel transform(Map)
}
class AnyTokenEndpoint{
    <<interface>>
    +Map download()
    +TokenModel transform(Map)
}
class DappsStakingEndpoint{
    +Map download()
    +DappsStakingModel transform(Map)
}
class AnyDeFiEndpoint{
    <<interface>>
    +Map download()
    +DeFiModel transform(Map)
}
class AnyNftEndpoint{
    <<interface>>
    +Map download()
    +NftModel transform(Map)
}

%% =======================================
%% Wallet connect
%% =======================================
class WalletConnectProvider{
    +walletId
    +connectStatus
    +connect()
}

class WalletConnectRepository{
    <<singleton>>
    +String walletId
    +String sessionStatus
    + update()
}

class ContractAbstract{
    <<abstract>>
}

class PushNotification{
    
}

%% =======================================
%% Views
%% =======================================
LandingView -- DashboardView
LandingView -- DetailView
DetailView -- BlockStatsDetailView
DetailView -- DappsStakingDetailView
DetailView -- DeFiDetailView
DetailView -- NftDetailView

%% =======================================
%% My Asset
%% =======================================
DashboardView -- PortfolioView
PortfolioView *-- PortfolioProvider
PortfolioProvider o-- TokenRepository
PortfolioProvider o-- DappsStakingRepository

PortfolioProvider o-- WalletConnectRepository

%% =======================================
%% Stats List
%% =======================================
DashboardView -- StatsListView
StatsListView *-- StatsListProvider
StatsListProvider o-- BlockStatsRepository
StatsListProvider o-- DappsStakingRepository
StatsListProvider o-- DeFiRepository
StatsListProvider o-- NftRepository
StatsListProvider o-- WalletConnectRepository

%% =======================================
%% Block Stats
%% =======================================
BlockStatsDetailView *-- BlockStatsDetailProvider
BlockStatsDetailProvider o-- BlockStatsRepository
BlockStatsRepository *-- BlockStatsEndpoint

%% =======================================
%% Token
%% =======================================
TokenRepository *-- AnyTokenEndpoint

%% =======================================
%% Dapps Staking
%% =======================================
DappsStakingDetailView *-- DappsStakingDetailProvider
DappsStakingDetailProvider o-- DappsStakingRepository
DappsStakingDetailProvider o-- DappsStakingContract
DappsStakingRepository *-- DappsStakingEndpoint

%% =======================================
%% DeFi
%% =======================================
DeFiDetailView *-- DeFiDetailProvider
DeFiDetailProvider o-- DeFiRepository
DeFiDetailProvider o-- WalletConnectRepository
DeFiRepository *-- AnyDeFiEndpoint

%% =======================================
%% NFT
%% =======================================
NftDetailView *-- NftDetailProvider
NftDetailProvider o-- NftRepository
NftDetailProvider o-- WalletConnectRepository
NftRepository *-- AnyNftEndpoint

%% =======================================
%% Wallet Connect
%% =======================================
DashboardView -- WalletConnectView
WalletConnectView *-- WalletConnectProvider
WalletConnectProvider o-- WalletConnectRepository
ContractAbstract -- WalletConnectRepository
ContractAbstract <|-- DappsStakingContract

```
