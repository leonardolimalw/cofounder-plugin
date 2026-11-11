# Marketplace

Um marketplace de plugins para o [Claude Code](https://code.claude.com/docs/pt/overview) e o [Codex](https://developers.openai.com/codex).

[Click here for the English version](README.en.md)

## Plugins disponíveis

| Plugin | Descrição |
|--------|-----------|
| [cofounder](skills/) | Um cofundador movido por IA que guia você da ideia ao app publicado na internet. |

## Instalando como plugin do Claude Code

Dentro do Claude Code, rode:

```
/plugin marketplace add locaweb/cofounder
/plugin install cofounder@locaweb
```

Para receber as atualizações automaticamente, ative o auto-update em `/plugin` → **Marketplaces** → **locaweb** → **Enable auto-update**. Para atualizar manualmente, rode `claude plugin update cofounder@locaweb` no terminal.

## Instalando como plugin do Codex

No terminal, adicione o marketplace:

```
codex plugin marketplace add locaweb/cofounder
```

Depois abra o `codex`, rode `/plugins`, instale o **cofounder** do marketplace **locaweb** e inicie uma nova sessão. Na primeira sessão, aprove o hook do cofounder em `/hooks`: é ele que ativa o cofounder no início de cada sessão. Também na primeira sessão, o cofounder pede sua aprovação uma vez para configurar o projeto (`.codex/config.toml` com acesso total, e a pasta marcada como confiável no Codex), para poder instalar ferramentas e rodar comandos sem pedir permissão a cada passo; isso vale a partir da sessão seguinte. Para atualizar, rode `codex plugin marketplace upgrade locaweb`.

## Verificando a instalação

Cada versão é publicada como um [GitHub Release](https://github.com/locaweb/cofounder/releases) com o `install.sh`, um tarball do diretório `skills/` e um `SHA256SUMS`. Os artefatos têm attestation de proveniência que prova que foram gerados pelo workflow `release.yml` a partir de um commit específico deste repositório. Para verificar, use o [GitHub CLI](https://cli.github.com) autenticado:

```bash
VERSION=v0.26.1
gh release download "$VERSION" --repo locaweb/cofounder --dir "cofounder-$VERSION"
cd "cofounder-$VERSION"
sha256sum -c SHA256SUMS   # no macOS: shasum -a 256 -c SHA256SUMS
gh attestation verify install.sh --repo locaweb/cofounder
gh attestation verify "cofounder-skills-$VERSION.tar.gz" --repo locaweb/cofounder
```

Se tudo passar, rode o `install.sh` verificado com `bash install.sh`.

## Licença

Functional Source License (FSL-1.1-ALv2) — veja [LICENSE](LICENSE).
