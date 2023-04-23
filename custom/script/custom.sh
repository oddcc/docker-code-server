#!/usr/bin/env bash

# install nvm and nodejs
NVM_VERSION=v0.39.7
rm -rf /config/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /root/.bashrc
. /root/.bashrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install --lts
nvm use --lts

# install pnpm
export SHELL=bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
cat <<'EOF' >> /root/.bashrc
# pnpm
export PNPM_HOME="/config/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
EOF

# install yarn
npm install --global yarn

# install ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  gpg --dearmor -o /etc/apt/keyrings/ngrok.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main" | \
  tee /etc/apt/sources.list.d/ngrok.list && \
  apt update
  apt install ngrok
  ngrok config add-authtoken 2inu6OHnOstKqOFU2VudAymO1cV_3ssZ11mXX7fa3NG5oufbr

# resolve node-canvas on arm64 issue
apt-get install -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev

# install java
apt-get install -y \
	openjdk-8-jdk-headless \
	openjdk-11-jdk-headless \
	openjdk-17-jdk-headless

# install python, make, g++, chromium-browser
apt-get install -y \
	make \
	g++ \
	python3 \
	chromium-browser \
	vim

# install golang
GOLANG_VERSION=1.22.3
curl -OL https://go.dev/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
tar -C /usr/local -xf go$GOLANG_VERSION.linux-arm64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.bashrc
rm go$GOLANG_VERSION.linux-arm64.tar.gz

# install maven
MAVEN_VERSION=3.9.7
curl -OL https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
tar -xf apache-maven-$MAVEN_VERSION-bin.tar.gz
mv apache-maven-$MAVEN_VERSION /opt/
echo "M2_HOME='/opt/apache-maven-$MAVEN_VERSION'" >> /root/.bashrc
echo 'PATH="$M2_HOME/bin:$PATH"' >> /root/.bashrc
echo 'export PATH' >> /root/.bashrc
rm apache-maven-$MAVEN_VERSION-bin.tar.gz

# update .bashrc
cp /root/.bashrc /config/.bashrc

# install extentions
for i in /tmp/custom/extensions/*; do /app/code-server/bin/code-server --force --extensions-dir /config/extensions --install-extension "$i"; done
extensions=(
    "golang.go"
    "k--kato.intellij-idea-keybindings"
    "VMware.vscode-boot-dev-pack"
    "vscjava.vscode-java-pack"
    "sonarsource.sonarlint-vscode"
    "hediet.vscode-drawio"
    "formulahendry.code-runner"
    "GitHub.vscode-github-actions"
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "WakaTime.vscode-wakatime"
    "ms-azuretools.vscode-docker"
    "Codeium.codeium"
    "bradlc.vscode-tailwindcss"
    "mtxr.sqltools"
    "mtxr.sqltools-driver-pg"
    "heybourn.headwind"
)

for ext in "${extensions[@]}"
do
    /app/code-server/bin/code-server --force --extensions-dir /config/extensions --install-extension "$ext"
done
